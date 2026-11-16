extends Control

const BATTLE_SCENE := "res://scenes/Game.tscn"
const ZONE_CONNECTIONS := [
	["Zone1", "Zone2"],
	["Zone1", "Zone3"],
	["Zone2", "Zone3"],
	["Zone2", "Zone4"],
	["Zone3", "Zone5"],
	["Zone4", "Zone5"],
]

@onready var zone_buttons: Array[Button] = [
	$Zones/Zone1,
	$Zones/Zone2,
	$Zones/Zone3,
	$Zones/Zone4,
	$Zones/Zone5,
]
@onready var zone_name_label: Label = $InfoPanel/ZoneName
@onready var zone_level_label: Label = $InfoPanel/ZoneLevel
@onready var zone_enemies_label: Label = $InfoPanel/ZoneEnemies
@onready var enter_button: Button = $InfoPanel/EnterButton

func _ready() -> void:
	for button in zone_buttons:
		button.pressed.connect(_on_zone_pressed.bind(button))
	enter_button.pressed.connect(_on_enter_pressed)
	enter_button.disabled = true

func _on_zone_pressed(button: Button) -> void:
	zone_name_label.text = button.text
	zone_level_label.text = "Nivel: —"
	zone_enemies_label.text = "Enemigos: —"
	enter_button.disabled = false

func _on_enter_pressed() -> void:
	get_tree().change_scene_to_file(BATTLE_SCENE)

func _draw() -> void:
	for connection in ZONE_CONNECTIONS:
		var from := get_node("Zones/" + connection[0]) as Button
		var to := get_node("Zones/" + connection[1]) as Button
		draw_line(from.position + from.size * 0.5, to.position + to.size * 0.5, Color(0.35, 0.42, 0.55), 4.0)
