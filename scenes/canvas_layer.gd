extends CanvasLayer

func _ready() -> void:
	GameManager.player_hp_changed.connect(on_player_hp_changed)
	$TextureProgressBar.max_value = 100
	$TextureProgressBar.value = 100

func on_player_hp_changed(amount : int):
	$PLayerHpLabel.text = "Player hp: " + str(amount)
	$TextureProgressBar.value = amount
	
