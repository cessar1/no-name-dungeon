extends Area2D
@export var radius := 100.0
@export var color := Color(0.828, 0.906, 0.944, 0.675)
@onready var collision := $CollisionShape2D
@export var depth_scale: float = 0.4
@export var segments: int = 64
var is_single_target: bool = false

signal target_selected(targets : Array[BattleUnit])

func _ready() -> void:
	create_collision()
	
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("click"):
		if get_overlapping_areas().size() > 0:
			var targets = get_overlapping_areas()
			target_selected.emit(targets)
			queue_free()


func get_area_points() -> PackedVector2Array:
	var points := PackedVector2Array()

	for i in segments:
		var angle := TAU * i / segments

		points.append(Vector2(
			cos(angle) * radius,
			sin(angle) * radius * depth_scale
		))

	return points

func create_collision() -> void:
	$CollisionShape2D.polygon = get_area_points()
	
func get_targets():
	return get_overlapping_bodies()





func _on_area_entered(area: Area2D) -> void:
	if area.has_method("show_selection_ring"):
		area.show_selection_ring()


func _on_area_exited(area: Area2D) -> void:
	if area.has_method("hide_selection_ring"):
	
		area.hide_selection_ring()
