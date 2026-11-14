extends Control

const PRE_BATTLE_SCENE := "res://scenes/PreBattle.tscn"

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(PRE_BATTLE_SCENE)

func _on_quit_pressed() -> void:
	get_tree().quit()
