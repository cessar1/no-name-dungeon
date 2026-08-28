extends Node2D

func _ready() -> void:
	# Importante estar seguro que la escena de combate siempre tenga enemigos
	var units = get_node("Units").get_children()
	
	# Me aseguro que la unidad seleccionada por default sea un enemigo sin importar la posicion en el array.
	for u in units:
		if u is Enemy:
			SelectionManager.select_enemy(u)
			
			break
			
	BattleManager._register_units(units)
	BattleManager.start_battle()
	
