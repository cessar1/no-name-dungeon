extends Node

signal battle_ended()
signal turn_started(unit: BattleUnit)

var units: Array[BattleUnit] = []
var current_index : int = 0
var time_between_turn : float = 0.5
var _battle_active : bool = false
var factions = ["Player, Enemy"]

func _register_units(all_units : Array):
	units.clear()
	
	for unit in all_units:
		if unit is BattleUnit:
			units.append(unit)
			
			if not unit.unit_died.is_connected(_on_unit_die):
				unit.unit_died.connect(_on_unit_die)

func start_battle():
	print("Start")
	if units.size() < 2:
		push_error("BattleManager: se necesitan al menos 2 unidades.")
		return
		
	_battle_active = true
	current_index = 0 #Si en el futuro queres hacer un restart battle
	battle_loop()

func battle_loop():
	while _battle_active:
		
		_purge_dead_units()
		
		if check_battle_over():
			break
		
		var current_unit: BattleUnit = units[current_index]
		
		turn_started.emit(current_unit)
		
		#if not is_instance_valid(current_unit):
			#print("Instancia invalida")
			#next_turn()
			#continue
		
		var target: BattleUnit = get_target(current_unit)
		
		if target == null:
			_end_battle()
			break
		
		await current_unit.play_turn(target)
		current_unit.finish_turn()
		#En caso de que el jugador termine el turno sin atacar.
		#await current_unit.turn_finished
		print(current_unit.name)
		await get_tree().create_timer(time_between_turn).timeout

		next_turn()

func _purge_dead_units():
	units = units.filter(
		func(u: BattleUnit) -> bool:
			return is_instance_valid(u) and u.is_alive()
	)

func check_battle_over():
	# Falta evaluar si el jugador no esta vivo
	if units.size() <= 1:
		var winner_faction := ""
		#if units.size() == 1 and is_instance_valid(units[0]):ssssssssssssssssssssssssssssssss
			#winner_faction = factions[units[0].get_faction()]
		_end_battle()
		return true
	return false

func _end_battle():
	print("Se termino el juego")
	_battle_active = false
	battle_ended.emit()

func get_target(current_unit: BattleUnit) -> BattleUnit:
	for unit : BattleUnit in units:
		if not is_instance_valid(unit):
			continue
		if unit.get_faction() != current_unit.get_faction() and unit.is_alive():
			return unit
	return null

func next_turn():
	current_index += 1
	if current_index >= units.size():
		current_index = 0

func _on_unit_die(unit: BattleUnit):
	print("Se ejecuta para ver si funciona en player")
	if not is_instance_valid(unit):
		return
		
	print("Unidad eliminada: ", unit.name)
	
	var idx := units.find(unit)
	if idx != -1:
		units.remove_at(idx)
		
	if idx < current_index:
		current_index = max(0, current_index - 1)
		
	unit.queue_free()
