extends Node

const PLAYER_BASE_STATS := preload("res://stats/player_base.tres")
const STARTING_SKILLS: Array[Skill] = [
	preload("res://skills/basic_attack.tres"),
	preload("res://skills/fire_ball.tres"),
	preload("res://skills/wind_strike.tres"),
]
const SAVE_PATH := "user://player_save.tres"

# Signal Global
signal skill_selected(name : String)


var player_state: PlayerState
var turn := "Player"
var last_battle_won := false

var skill_points: int:
	get:
		return player_state.skill_points
	set(value):
		player_state.skill_points = value

signal skill_points_changed(new_value)

signal enemy_count_changed(value : int)

signal player_hp_changed(amount: int)
signal player_max_hp_changed(amount : int)

signal skill_preview_finished()

signal enemy_died()
signal turn_changed(turn: String)

signal enemy_selected(enemy: Enemy)

func add_skill_points(value: int):
	player_state.skill_points += value
	skill_points_changed.emit(skill_points)
	save_state()

const PASSIVE_CATALOG: Array[PassiveSkill] = [
	preload("res://passives/iron_skin.tres"),
	preload("res://passives/light_feet.tres"),
	preload("res://passives/cold_mind.tres"),
]

var learned_passives: Array[PassiveSkill]:
	get:
		return player_state.learned_passives

func has_learned_passive(passive: PassiveSkill) -> bool:
	return player_state.learned_passives.has(passive)

func can_learn_passive(passive: PassiveSkill) -> bool:
	return not has_learned_passive(passive) and skill_points >= passive.cost

func learn_passive(passive: PassiveSkill) -> bool:
	if not can_learn_passive(passive):
		return false

	player_state.skill_points -= passive.cost
	player_state.learned_passives.append(passive)
	skill_points_changed.emit(skill_points)
	save_state()
	return true

func _ready() -> void:
	player_state = _load_state()
	if player_state == null:
		player_state = _create_default_player_state()

func save_state() -> void:
	var error := ResourceSaver.save(player_state, SAVE_PATH)
	if error != OK:
		push_error("No se pudo guardar el estado del jugador: %s" % error)

func _load_state() -> PlayerState:
	if not ResourceLoader.exists(SAVE_PATH):
		return null

	var state := ResourceLoader.load(SAVE_PATH) as PlayerState
	if state == null:
		push_warning("No se pudo cargar el estado del jugador; se usará uno nuevo.")
	return state

func _create_default_player_state() -> PlayerState:
	# Provisional: hasta que exista la creación de personaje, el estado base
	# sale de la plantilla de stats y de las skills iniciales.
	var state := PlayerState.new()
	state.stats = PLAYER_BASE_STATS.duplicate(true)
	state.skills.assign(STARTING_SKILLS)
	return state
