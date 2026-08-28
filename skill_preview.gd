extends Area2D
@export var radius := 100.0
@export var color := Color(0.092, 0.175, 0.213, 0.675)
@onready var collision := $CollisionShape2D

func _ready() -> void:
	collision.shape.radius = radius
	
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	queue_redraw()
	
#	Esto es temporal
	if Input.is_action_just_pressed("click"):
		if get_overlapping_bodies().size() > 0:
			GameManager.skill_preview_finished.emit(global_position)
			queue_free()
	#var targets = get_targets()
	#for target in targets:
		#if target.has_method("highlight"):
			#target.highlight(true)
	
func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color )
	draw_arc(
		Vector2.ZERO,
		radius,
		0,
		TAU,
		64,
		color,
		3.0
	)
	
func get_targets():
	return get_overlapping_bodies()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("highlight"):
		body.highlight(true)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("highlight"):
	
		body.highlight(false)
