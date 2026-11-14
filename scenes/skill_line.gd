class_name SkillLine extends Label

func setup(skill: Skill) -> void:
	text = "%s — %d energía" % [skill.skill_name, skill.energy_cost]
