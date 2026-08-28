class_name Skill_slot extends Control

@export var skill_name : String

func _ready() -> void:
	#$Attack.disabled = false
	BattleManager.turn_started.connect(_on_turn_started)
	BattleManager.battle_ended.connect(_on_battle_ended)
	print(skill_name)
	
func _on_turn_started(unit: BattleUnit):
	print("unit.name")
	$Attack.disabled = not (unit is Player)

func _on_battle_ended():

	$Attack.disabled = true
	
func _on_attack_pressed() -> void:
	print(skill_name)
	GameManager.skill_selected.emit(skill_name)

func disable_skill_slots(value : bool):
	$Attack.disabled = value
