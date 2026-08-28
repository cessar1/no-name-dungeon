extends Node

var selected_enemy  = null

func select_enemy(enemy : BattleUnit):
	print(enemy.name)
	if selected_enemy:
		selected_enemy.deselect()
		
	selected_enemy = enemy
	GameManager.enemy_selected
	selected_enemy.select()
	
