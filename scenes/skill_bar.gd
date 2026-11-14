class_name  SkillBar extends PanelContainer

const SKILL_SLOT_SCENE = preload("res://scenes/skill_slot.tscn")
signal skill_selected(skill : Skill)

# Recibe de SkillSlot el skill seleccionado, BattleManager se conecta a esta señal.
func _on_skill_slot_selected(skill):
	skill_selected.emit(skill)
	
# BattleManager lo llama y pasa el jugador actual.
func show_skills(unit: BattleUnit):
	visible = true
	clear_slots()
	
	for skill in unit.get_skills():
		var slot = SKILL_SLOT_SCENE.instantiate()
		slot.skill_selected.connect(_on_skill_slot_selected)

		slot.setup(skill)
		$MarginContainer/BoxContainer.add_child(slot)

	refresh_availability(unit)

# Habilita o deshabilita cada slot según la energía del jugador actual.
func refresh_availability(unit: BattleUnit):
	for slot in $MarginContainer/BoxContainer.get_children():
		slot.set_available(unit.can_use_skill(slot.skill))
		
		
func clear_slots():
	for child in $MarginContainer/BoxContainer.get_children():
		child.queue_free()

func _on_unit_selected(unit : BattleUnit):
	show_skills(unit)
