class_name BattleUnit
extends Area2D

const ENERGY_REGEN := 10.0

signal turn_finished
signal unit_died(unit : BattleUnit)
signal unit_death_finished(unit : BattleUnit)
signal unit_selected(unit: BattleUnit)
signal unit_hp_changed(unit: BattleUnit, current_hp: int)
signal unit_energy_changed(unit: BattleUnit, current_energy: float, max_energy: float)

@export var _is_alive := true
@export var skills : Array[Skill]
@export var stats : Stat

var current_hp : float
var current_energy : float
var max_hp : float
var max_energy : float

func _ready() -> void:
	current_hp = stats.hp
	max_hp = stats.hp
	current_energy = stats.energy
	max_energy = stats.energy
	
func is_alive():
	return _is_alive
	
func get_hit_chance(evasion, accuracy):
	return accuracy / ( accuracy + evasion )

func can_use_skill(skill: Skill) -> bool:
	return is_alive() and current_energy >= skill.energy_cost

func regenerate_energy() -> void:
	current_energy = minf(current_energy + ENERGY_REGEN, max_energy)
	unit_energy_changed.emit(self, current_energy, max_energy)

func get_damage(damage : int):
	print("llega 3")
	if not is_alive():
		return 
		
	current_hp -= damage
	unit_hp_changed.emit(self, current_hp)
	
	# Ejecuta animaciones o lo que el player necesite
	on_damage_received(damage)
	
	if current_hp <= 0:
		_is_alive = false
		die()
	
func die():
	unit_died.emit(self)
	_is_alive = false
	await on_death()
	unit_death_finished.emit(self)

func get_skills():
	return skills

func on_damage_received(damage):
	pass

func on_death():
	pass
