class_name Skill extends Resource

@export_category("General")
@export var skill_name: String
@export var requires_target: bool
@export var damage: int

@export_category("Cost")
@export var energy_cost: int
@export var cooldown: int

var target_type = "" #Ally, Enemy
@export var texture : Texture2D
@export var execution_time: float = 0.8
@export_range(0.0, 1.0,0.1) var execution_variation: float = 0.15

func get_execution_time() -> float:
	return execution_time * randf_range(
		1.0 - execution_variation,
		1.0 + execution_variation
	)
	
func execute(user : BattleUnit, target: BattleUnit):
	if not is_valid_target(target):
		return
		
	target.get_damage(damage)

# Implementar si el target es correcto
func is_valid_target(target : BattleUnit):
	return target.is_alive()
	
	
# Falta implementar
func is_on_cooldown():
	return false
