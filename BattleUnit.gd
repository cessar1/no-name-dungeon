class_name BattleUnit
extends Area2D

signal turn_finished
signal unit_died(unit : BattleUnit)

enum Faction {
	PLAYER,
	ENEMY
}
@export var _faction : Faction
@export var _is_alive := true
@export var stats : Stat

var current_hp : float
var current_energy : float

func _ready() -> void:
	print("Super")
	print(stats.hp)
	current_hp = stats.hp
	current_energy = stats.energy

func get_faction():
	return _faction

func finish_turn():
	turn_finished.emit()

func is_alive():
	return _is_alive
	
func get_hit_chance(evasion, accuracy):
	return accuracy / ( accuracy + evasion )
	
func play_turn(target : BattleUnit):
	pass

func get_damage(value : int):
	pass
