extends Control

const PRE_BATTLE_SCENE := "res://scenes/PreBattle.tscn"

func _ready() -> void:
	%ResultLabel.text = "Victoria" if GameManager.last_battle_won else "Derrota"

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(PRE_BATTLE_SCENE)
