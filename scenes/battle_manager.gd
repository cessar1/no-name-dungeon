extends Node

enum Turn {
	PLAYER,
	ENEMY
}
signal battle_ended(player_won: bool)
signal turn_started(unit: BattleUnit)
signal player_selected(unit: BattleUnit)

var active_players: Array[BattleUnit]
var active_enemies: Array[BattleUnit]

var actions_remaining: int = 0
var enemies_to_act: Array[BattleUnit]

var selected_player: BattleUnit
#var selected_target: BattleUnit
var skill_bar : SkillBar
var current_turn : Turn

var battle_over := false
var battle_result_announced := false
var player_won := false
var units_dying := 0

func start_battle():
	if battle_over:
		return
	start_player_turn()
	
func start_player_turn():
	if battle_over:
		return

	current_turn = Turn.PLAYER
	actions_remaining  = active_players.size()

	for player in active_players:
		player.regenerate_energy()

	if skill_bar and selected_player:
		skill_bar.refresh_availability(selected_player)

func finish_player_action():
	if battle_over:
		return

	actions_remaining -= 1
	
	if actions_remaining <= 0:
		change_turn()
		
func start_enemy_turn():
	if battle_over:
		return

	current_turn = Turn.ENEMY

	enemies_to_act = active_enemies.duplicate()

	enemies_to_act.shuffle()
	execute_next_enemy_action()

func execute_next_enemy_action():
	if battle_over:
		return

	if enemies_to_act.is_empty():
		change_turn()
		return
	# Eliminados un siguen en el array
	var enemy : BattleUnit  = enemies_to_act.pop_front()
	if active_players.is_empty():
		return
		
	await enemy.execute_action(active_players)

	if battle_over:
		return

	execute_next_enemy_action()

func change_turn():
	if battle_over:
		return

	#print("ANTES DE CAMBIAR TURNO")
	#print("active_enemies:", active_enemies.size())
	if current_turn == Turn.PLAYER:
		start_enemy_turn()
	else:
		start_player_turn()

func register_unit(unit: BattleUnit):
	unit.unit_died.connect(_on_unit_died)
	unit.unit_death_finished.connect(_on_unit_death_finished)

	if unit is Enemy:
		active_enemies.append(unit)
	elif unit is Player:
		active_players.append(unit)
		unit.unit_selected.connect(_on_unit_selected)

func _on_unit_selected(unit: BattleUnit):
	if battle_over:
		return

	if current_turn != Turn.PLAYER:
		return
		
	select_player(unit)
	skill_bar.show_skills(unit)

## Se conecta a la barra de skills del jugador actual
func setup_ui(ui : SkillBar):
	skill_bar = ui
	skill_bar.skill_selected.connect(_on_skill_selected)
	
# Recibe de SkillBar el skill seleccionado
func _on_skill_selected(skill : Skill):
	if battle_over:
		return

	if current_turn != Turn.PLAYER:
		return

	if not (selected_player is Player):
		return
		
	var skill_preview_scene = preload("res://scenes/skill_preview.tscn")
	var skill_preview = skill_preview_scene.instantiate()
	add_child(skill_preview)
	
	var raw_targets = await skill_preview.target_selected
	var targets: Array[BattleUnit] = []
	for target in raw_targets:
		if target is BattleUnit:
			targets.append(target as BattleUnit)

	var player := selected_player as Player
	var casted: bool = player.use_skill(skill, targets)

	if casted:
		if skill_bar:
			skill_bar.refresh_availability(player)
		finish_player_action()

func _on_unit_died(unit : BattleUnit):
	units_dying += 1

	if unit in active_players:
		active_players.erase(unit)
	elif unit in active_enemies:
		active_enemies.erase(unit)

	if active_players.is_empty():
		_set_battle_result(false)
	elif active_enemies.is_empty():
		_set_battle_result(true)

# Marca el resultado apenas muere la última unidad, pero no lo anuncia
# hasta que termina la animación de muerte (ver _on_unit_death_finished).
func _set_battle_result(won: bool) -> void:
	if battle_over:
		return

	battle_over = true
	player_won = won

func _on_unit_death_finished(_unit: BattleUnit) -> void:
	units_dying = maxi(units_dying - 1, 0)

	if not battle_over or battle_result_announced or units_dying > 0:
		return

	battle_result_announced = true
	battle_ended.emit(player_won)

func select_player(current_player: BattleUnit):
	if is_instance_valid(selected_player):
		selected_player.hide_selection_ring()

	selected_player = current_player
	current_player.show_selection_ring()
	player_selected.emit(current_player)

func clear_selection():
	if is_instance_valid(selected_player):
		selected_player.hide_selection_ring()

	selected_player = null
