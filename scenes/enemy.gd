
class_name Enemy extends BattleUnit

@export var hp = 100

var speed = 300

signal hp_changed(amount : float)

var final_position : Vector2

@onready var target = get_tree().get_first_node_in_group("player")

enum {
	ENTERING,
	IDLE,
	ATACKING
}

var state = ENTERING

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	
	if stats == null:
		warnings.append("Debes asignar un recurso a Stats.")
	
	return warnings
		

func _ready() -> void:
	update_configuration_warnings()
	update_hp(stats.hp)
	GameManager.enemy_selected.connect(_on_enemy_selected)

#func _physics_process(delta: float) -> void:
	##Arreglar esta verga
	#print("Corriendo")
	#if target:
		#var target_direction = position.direction_to(target.position)
		#velocity = target_direction * 200
		#move_and_slide()
func _on_enemy_selected(enemy):
	
	$GPUParticles2D.emitting = enemy == self
func get_calculated_damage():
#	Player defense - evasion - resistance
	return stats.attack
	
## Apartado visual temporal
func highlight(value):
	if value:
		$Sprite2D.modulate = Color.YELLOW
	else:
		$Sprite2D.modulate = Color.WHITE


func change_state(new_state : int):
	state = new_state
	
func play_turn(target : BattleUnit):
	var hit_chance = get_hit_chance(target.stats.evasion, stats.accuracy)
	if randf() < hit_chance:
		await attack(target)
	else:
		print("%s Miss his attack" % name)
		target.show_miss()
	finish_turn()
	

func attack(target : BattleUnit):
	await get_tree().create_timer(0.5).timeout
	var calculated_damage = get_calculated_damage()
	await target.get_damage(calculated_damage)
	
	await get_tree().create_timer(0.3).timeout
	
func get_damage(damage: int):
	print("The enemy gets %d" % damage)
	$AnimationPlayer.play("hurt")
	
	await $AnimationPlayer.animation_finished
	
	if hp > 0:
		hp -= damage
		update_hp(hp)
		
	if hp <= 0:
		get_reward()
		die()

func update_hp(hp: int):
	
	$VBoxContainer/Label.text = "Bartolito (%s)" % str(hp)
	
func die():
	#Si hay una animacion de muerte podría ir aca await anim.muerte.animation_finished
	unit_died.emit(self)

func get_reward():
	var random_amount = randi_range(1,8)
	print(random_amount)
	
	GameManager.add_skill_points(random_amount)

func show_miss():
	show_text("Miss")
	
func show_text(text):
	$Miss.text = text
	$Miss.modulate.a = 1.0
	$Miss.position = Vector2(0, -20)
	
	var tween = create_tween()
	tween.tween_property($Miss, "position", Vector2(0, -160), 0.6)
	tween.parallel().tween_property($Miss, "modulate:a", 0.0, 0.6)

func select():
	$GPUParticles2D.emitting = true

func deselect():
	$GPUParticles2D.emitting = false


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			SelectionManager.select_enemy(self)
	
