class_name Game
extends Node2D

const ENEMY_SCENE = preload("res://scenes/enemy.tscn")
const PLAYER_SCENE = preload("res://scenes/Player.tscn")
const RESULT_SCENE := "res://scenes/BattleResult.tscn"

@onready var battle_manager = $BattleManager
@onready var positions = $Positions.get_children()
@onready var units: Node2D = $Units
@onready var skill_bar: SkillBar = %SkillBar

var available_positions = []


func _ready() -> void:
	available_positions = positions.duplicate()
	battle_manager.setup_ui(skill_bar)
	battle_manager.battle_ended.connect(_on_battle_ended)

	spawn_player()
	spawn_enemy()
	spawn_enemy()
	battle_manager.start_battle()


func _on_battle_ended(player_won: bool) -> void:
	GameManager.last_battle_won = player_won
	skill_bar.visible = false
	battle_manager.clear_selection()
	get_tree().change_scene_to_file(RESULT_SCENE)


func spawn_player() -> void:
	var player: BattleUnit = PLAYER_SCENE.instantiate()
	player.global_position = positions[0].global_position

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
