
class_name Enemy extends BattleUnit

@onready var animator : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super._ready()
	unit_hp_changed.connect(_on_unit_hp_changed)
	_on_unit_hp_changed(self,current_hp)


func get_calculated_damage():
#	Player defense - evasion - resistance
	return stats.attack

func attack(target : BattleUnit):
	await get_tree().create_timer(0.5).timeout
	var calculated_damage = get_calculated_damage()
	await target.get_damage(calculated_damage)
	
	await get_tree().create_timer(0.3).timeout
	
func execute_action(active_players : Array[BattleUnit]):
	var target = choose_target(active_players)
	if not target.is_alive():
		#Buscar si es posible al proximo target
		return
	var skill = skills[0]
	var execution_time = skill.get_execution_time()
	await get_tree().create_timer(execution_time).timeout
	skill.execute(self, target)

func choose_target(players : Array[BattleUnit]):
	return players.pick_random()
	
func on_damage_received(damage):
	TextDamage.display_number( damage, $LabelPosition.global_position, false)
	animator.play("hurt")

func on_death():
	#Si hay una animacion de muerte podría ir aca await anim.muerte.animation_finished
	animator.play("die")
	await animator.animation_finished
	get_reward()
	queue_free()

func get_reward():
	var random_amount = randi_range(1,8)
	
	GameManager.add_skill_points(random_amount)


func show_selection_ring():
	$SelectionRing.emitting = true

func hide_selection_ring():
	$SelectionRing.emitting = false

# No se usa de momento.
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			unit_selected.emit(self)
	
func _on_unit_hp_changed(unit : BattleUnit, current_hp : float):
	$VBoxContainer/TextureProgressBar.value =  (current_hp * 100) / max_hp 
	$VBoxContainer/Label.text = "Bartolito (%s)" % int(current_hp)
