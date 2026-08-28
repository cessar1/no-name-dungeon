class_name Dungeon extends Node2D

var skill_preview_scene = preload("res://scenes/skill_preview.tscn")
var skill_scene = preload("res://scenes/skill.tscn")
var enemy_scene = preload("res://scenes/Enemy.tscn")

var skill_selected = null
@export var max_enemy_count = 5
var enemy_count = 0

var skills = {
	"normal_attack" : preload("res://scenes/skill.tscn"),
	"magic_attack" : preload("res://scenes/skill.tscn")
}

#func _ready() -> void:
	#GameManager.skill_selected.connect(_on_skill_selected)
	#GameManager.skill_preview_finished.connect(_on_skill_preview_finished)

#func _on_skill_preview_finished(_position : Vector2):
##	falta agregar skill data -> 
	#var skill = skill_scene.instantiate()
	#skill.position = _position
	#add_child(skill)

	#
#func skill_preview(name : String):
	#var skill_preview = skill_preview_scene.instantiate()
	#add_child(skill_preview)
#
#func _on_skill_selected(name : String):
	#skill_preview(name) 
