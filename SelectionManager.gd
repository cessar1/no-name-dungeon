extends Node

var selected_actor: BattleUnit = null


func select_actor(unit: BattleUnit):
	if selected_actor:
		selected_actor.hide_selection_ring()

	selected_actor = unit
	selected_actor.show_selection_ring()


func clear_selection():
	if selected_actor:
		selected_actor.hide_selection_ring()

	selected_actor = null


func get_selected_actor() -> BattleUnit:
	return selected_actor
