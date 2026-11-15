class_name Game
extends Node2D

const ENEMY_SCENE = preload("res://scenes/enemy.tscn")
const PLAYER_SCENE = preload("res://scenes/Player.tscn")
const RESULT_SCENE := "res://scenes/BattleResult.tscn"

@onready var battle_manager = $BattleManager
@onready var positions = $Positions.get_children()
@onready var party_positions: Array[Marker2D] = [
	positions[0] as Marker2D,
	%PartyPosition1,
	%PartyPosition2,
]
@onready var units: Node2D = $Units
@onready var skill_bar: SkillBar = %SkillBar
@onready var pass_turn_button: Button = %PassTurnButton
@onready var canvas_layer: BattleCanvasLayer = $CanvasLayer

var available_positions = []


func _ready() -> void:
	available_positions = positions.duplicate()
	for position in party_positions:
		available_positions.erase(position)
	battle_manager.setup_ui(skill_bar)
	battle_manager.battle_ended.connect(_on_battle_ended)
	pass_turn_button.pressed.connect(battle_manager.finish_player_turn)

	spawn_party()
	canvas_layer.setup_party(battle_manager.active_players)
	spawn_enemy()
	spawn_enemy()
	battle_manager.start_battle()


func _on_battle_ended(player_won: bool) -> void:
	GameManager.last_battle_won = player_won
	skill_bar.visible = false
	battle_manager.clear_selection()
	get_tree().change_scene_to_file(RESULT_SCENE)


func spawn_party() -> void:
	var members := GameManager.party_state.members
	for i in members.size():
		if i >= party_positions.size():
			break
		spawn_party_member(members[i], party_positions[i])

func spawn_party_member(member: PlayerState, position: Marker2D) -> void:
	var player: BattleUnit = PLAYER_SCENE.instantiate()
	player.stats = member.stats
	player.skills.assign(member.skills)
	player.global_position = position.global_position

	units.add_child(player)

	battle_manager.register_unit(player)


func spawn_enemy() -> void:
	var position := get_random_available_position()

	if position == null:
		return

	var enemy: BattleUnit = ENEMY_SCENE.instantiate()
	enemy.global_position = position.global_position

	units.add_child(enemy)

	battle_manager.register_unit(enemy)


func get_random_available_position() -> Marker2D:
	if available_positions.is_empty():
		return null

	var position = available_positions.pick_random()
	available_positions.erase(position)

	return position
