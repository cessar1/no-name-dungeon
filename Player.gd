class_name Player extends BattleUnit

@onready var animator : AnimationPlayer = $AnimationPlayer

func use_skill(skill: Skill, targets: Array[BattleUnit]) -> bool:
	if not can_use_skill(skill):
		return false

	if targets.is_empty():
		return false

	for target in targets:
		if target == null or not skill.is_valid_target(target):
			return false

	current_energy -= skill.energy_cost
	unit_energy_changed.emit(self, current_energy, max_energy)

	for target in targets:
		skill.execute(self, target)

	return true
	
func on_damage_received(damage):
	animator.play("hurt")
	$AudioStreamPlayer.pitch_scale = randf_range(0.5, 1.2)
	$AudioStreamPlayer.play()
	
func on_death():
	animator.play("die")
	await animator.animation_finished
	queue_free()

# No se si esto esta bueno tenerlo aca
func show_selection_ring():
	TextDamage.display_number( randi_range(0,10), $LabelPosition.global_position, false)
	$SelectionRing.emitting = true

func hide_selection_ring():
	$SelectionRing.emitting = false



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			unit_selected.emit(self)
