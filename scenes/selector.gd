class_name Selector extends Area2D

@export var casting_time =  2.0

func _ready() -> void:
	#$Timer.wait_time = casting_time
	#$CollisionShape2D.shape.radius = radius
	
	await get_tree().create_timer(1.0).timeout
	queue_free()


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	select_enemy(body)

func select_enemy(enemy):
	GameManager.enemy_selected.emit(enemy)
	#print("Enemigo seleccionado", enemy)

# A este enemigo se le hará daño desde la funcion attack en el nodo Player
# Se instancia el selector y este envia la señal de a que enemigo hay que aplicarle el daño

	
