class_name Skill_slot extends Control

var skill_name : String
signal skill_selected(skill : Skill)
var skill : Skill

func setup(skill_data : Skill):
	skill = skill_data
	skill_name = skill.skill_name
	name = skill.skill_name
	#$SkillButton.text = skill.skill_name
	$Icon.texture = skill.texture

func _on_skill_button_pressed() -> void:
	skill_selected.emit(skill)
	
func set_available(value : bool):
	$SkillButton.disabled = not value
