extends Control

const MAP_SCENE := "res://scenes/Map.tscn"

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(MAP_SCENE)

func _on_quit_pressed() -> void:
	get_tree().quit()
