extends Control

const COMBAT_SCENE := "res://scenes/Game.tscn"
const PASSIVE_ROW_SCENE := preload("res://scenes/passive_row.tscn")
const SKILL_LINE_SCENE := preload("res://scenes/skill_line.tscn")

var _passive_rows: Array[PassiveRow] = []

func _ready() -> void:
	GameManager.skill_points_changed.connect(_on_skill_points_changed)
	_update_skill_points(GameManager.skill_points)
	_show_player_summary()
	_build_passive_rows()

func _on_skill_points_changed(new_value: int) -> void:
	_update_skill_points(new_value)
	_update_passive_rows()

func _update_skill_points(value: int) -> void:
	%SkillPointsLabel.text = "Skill Points: %d" % value

func _show_player_summary() -> void:
	var stats := GameManager.player_state.stats
	%HpLabel.text = "HP: %d" % int(stats.hp)
	%EnergyLabel.text = "Energía: %d" % int(stats.energy)

	for skill in GameManager.player_state.skills:
		var line := SKILL_LINE_SCENE.instantiate() as SkillLine
		%SkillsList.add_child(line)
		line.setup(skill)

func _build_passive_rows() -> void:
	for passive in GameManager.PASSIVE_CATALOG:
		var row := PASSIVE_ROW_SCENE.instantiate() as PassiveRow
		%PassivesList.add_child(row)
		row.setup(passive)
		row.learn_requested.connect(_on_learn_passive_pressed)
		_passive_rows.append(row)

	_update_passive_rows()

func _on_learn_passive_pressed(passive: PassiveSkill) -> void:
	# skill_points_changed se encarga de actualizar los botones.
	GameManager.learn_passive(passive)

func _update_passive_rows() -> void:
	for i in GameManager.PASSIVE_CATALOG.size():
		var passive := GameManager.PASSIVE_CATALOG[i]
		_passive_rows[i].update_state(
			GameManager.has_learned_passive(passive),
			GameManager.skill_points,
		)

func _on_start_battle_pressed() -> void:
	get_tree().change_scene_to_file(COMBAT_SCENE)
