class_name Player extends BattleUnit
@onready var animator := $AnimationPlayer
@export var speed: float = 200.0

var _is_my_turn : bool = false
var _current_skill = null

enum{
	IDLE,
	ATTACKING,
	DEAD
}

var state = ATTACKING

func _ready() -> void:
	super._ready()
	#GameManager.skill_selected.connect(_on_skill_selected)

func get_damage(damage : int):
	if not is_alive():
		## Como afecta a la routine si hago un early return
		## Continua el flujo normalmente?
		return
	animator.play("hurt")
	show_damage(damage)
	await animator.animation_finished

	current_hp -= damage

	#Enviar a la ui la actualizacion
	GameManager.player_hp_changed.emit(current_hp)

	if current_hp <= 0:
		_is_alive = false
		await die()

func die():
	# Si hay animacion se espera a que termine y luego se continua con el borrado del nodo.
	animator.play("die")
	await animator.animation_finished
	state = DEAD
	unit_died.emit(self)
	
func play_turn(target : BattleUnit):
	#var enemy : BattleUnit = await GameManager.enemy_selected
	var current_skill = await GameManager.skill_selected
	var enemy = SelectionManager.selected_enemy
	var hit_chance = get_hit_chance(enemy.stats.evasion, stats.accuracy)
	if randf() < hit_chance:
		var damage = _calculate_damage(current_skill)
		await enemy.get_damage(damage)

	else:
		target.show_miss()
	finish_turn()
	


func _calculate_damage(skill_name : String):
	match skill_name:
		"normal_attack" : return 30
		"magic_attack" : return 60
	return 10
		
#func _on_skill_selected(skill_name : String):
	#_current_skill =  skill_name
	
func show_text(text):
	print("Miss")
	$Miss.text = text
	$Miss.modulate.a = 1.0
	$Miss.position = Vector2(0, -20)
	
	var tween = create_tween()
	tween.tween_property($Miss, "position", Vector2(0, -160), 1.2)
	tween.parallel().tween_property($Miss, "modulate:a", 0.0, 1.2)
	
func show_damage(amount: int) -> void:
	$Label.text = str(amount)
	$Label.modulate.a = 1.0  # por si ya había hecho fade
	$Label.position = Vector2(0, -20)  # posición inicial sobre el enemigo
	
	var tween = create_tween()
	tween.tween_property($Label, "position", Vector2(0, -160), 1.2)
	tween.parallel().tween_property($Label, "modulate:a", 0.0, 1.2)

func show_miss():
	show_text("Miss")
