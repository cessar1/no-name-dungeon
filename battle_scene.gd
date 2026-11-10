extends Node2D

#@onready var spawn_positions = $Positions.get_children()
#var available_positions: Array[Marker2D] = []
#
#const ENEMY_SCENE = preload("res://scenes/enemy.tscn")
#const PLAYER_SCENE = preload("res://scenes/Player.tscn")
#
#
#func _ready():
	#for position in $Positions.get_children():
		#available_positions.append(position)
		#
	##spawn_player()
	#spawn_enemy()
	#spawn_enemy()
	#
#
#func spawn_player():
	#var warrior = PLAYER_SCENE.instantiate()
	#warrior.position = $"PlayerPositions/0".position
	#$PlayerParty.add_child(warrior)
	#BattleManager.register_unit(warrior)
	#BattleManager.start_battle()
	#
#func spawn_enemy():
	#if available_positions.is_empty():
		#return
#
	#var position = get_random_available_position()
#
	#var enemy = ENEMY_SCENE.instantiate()
#
	#enemy.global_position = position.global_position
#
	#$EnemyParty.add_child(enemy)
#
	#BattleManager.register_unit(enemy)
	#
#func get_random_available_position() -> Marker2D:
	#if available_positions.is_empty():
		#return null
	#
	#var position = available_positions.pick_random()
	#available_positions.erase(position)
#
	#return position
