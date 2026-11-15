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


var party_state: PartyState
var turn := "Player"
var last_battle_won := false
var _migrated_save := false

# Compatibilidad: PreBattle y el combate actual todavía leen al primer miembro.
var player_state: PlayerState:
	get:
		if party_state == null or party_state.members.is_empty():
			return null
		return party_state.members[0]

var skill_points: int:
	get:
		return party_state.skill_points
	set(value):
		party_state.skill_points = value

signal skill_points_changed(new_value)

signal enemy_count_changed(value : int)

signal player_hp_changed(amount: int)
signal player_max_hp_changed(amount : int)

signal skill_preview_finished()

signal enemy_died()
signal turn_changed(turn: String)

signal enemy_selected(enemy: Enemy)

func add_skill_points(value: int):
	party_state.skill_points += value
	skill_points_changed.emit(skill_points)
	save_state()

const PASSIVE_CATALOG: Array[PassiveSkill] = [
	preload("res://passives/iron_skin.tres"),
	preload("res://passives/light_feet.tres"),
	preload("res://passives/cold_mind.tres"),
]

var learned_passives: Array[PassiveSkill]:
	get:
		return party_state.learned_passives

func has_learned_passive(passive: PassiveSkill) -> bool:
	return party_state.learned_passives.has(passive)

func can_learn_passive(passive: PassiveSkill) -> bool:
	return not has_learned_passive(passive) and skill_points >= passive.cost

func learn_passive(passive: PassiveSkill) -> bool:
	if not can_learn_passive(passive):
		return false

	party_state.skill_points -= passive.cost
	party_state.learned_passives.append(passive)
	skill_points_changed.emit(skill_points)
	save_state()
	return true

func _ready() -> void:
	party_state = _load_party_state()
	if party_state == null:
		party_state = _create_default_party_state()
	elif _migrated_save:
		save_state()

func save_state() -> void:
	var error := ResourceSaver.save(party_state, SAVE_PATH)
	if error != OK:
		push_error("No se pudo guardar el estado de la party: %s" % error)

func _load_party_state() -> PartyState:
	if not ResourceLoader.exists(SAVE_PATH):
		return null

	var resource := ResourceLoader.load(SAVE_PATH)
	if resource is PartyState:
		if resource.members.is_empty() or resource.members.has(null):
			push_warning("La party guardada no tiene miembros válidos; se usará una nueva.")
			return null
		return resource
	if resource is PlayerState:
		return _migrate_player_state(resource)

	push_warning("No se pudo cargar el estado de la party; se usará uno nuevo.")
	return null

func _migrate_player_state(old_state: PlayerState) -> PartyState:
	var party := PartyState.new()
	# El recurso cargado apunta al save; si se guarda como subrecurso del
	# PartyState en el mismo archivo, Godot lo anula por referencia circular.
	old_state.resource_path = ""
	party.members.append(old_state)
	party.skill_points = old_state.skill_points
	party.learned_passives.assign(old_state.learned_passives)
	old_state.skill_points = 0
	old_state.learned_passives.clear()
	_fill_party(party)
	_migrated_save = true
	return party

func _create_default_party_state() -> PartyState:
	var party := PartyState.new()
	_fill_party(party)
	return party

func _fill_party(party: PartyState) -> void:
	while party.members.size() < PartyState.MAX_MEMBERS:
		party.members.append(_create_default_member())

func _create_default_member() -> PlayerState:
	# Provisional: hasta que exista creación de personaje, todos los miembros
	# salen de la plantilla de stats y de las skills iniciales.
	var member := PlayerState.new()
	member.stats = PLAYER_BASE_STATS.duplicate(true)
	member.skills.assign(STARTING_SKILLS)
	return member
