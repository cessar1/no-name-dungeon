extends Node

var population := 0
var max_population := 0
var skill_points := 0
var turn := "Player"
signal skill_points_changed(new_value)

signal enemy_count_changed(value : int)

signal player_hp_changed(amount: int)
signal player_max_hp_changed(amount : int)

signal skill_preview_finished()
signal skill_selected(name : String)

signal enemy_died()
signal turn_changed(turn: String)

signal enemy_selected(enemy: Enemy)

func add_skill_points(value: int):
	skill_points += value
	skill_points_changed.emit(skill_points)
	print("nuevos puntos habilitados")
