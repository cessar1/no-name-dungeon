extends Control

const BATTLE_SCENE := "res://scenes/Game.tscn"
# Conexiones provisionales entre los nodos del mapa; se reemplazarán cuando las zonas se definan por datos.
const ZONE_CONNECTIONS := [
	["Zone1", "Zone2"],
	["Zone1", "Zone3"],
	["Zone2", "Zone3"],
	["Zone2", "Zone4"],
	["Zone3", "Zone5"],
	["Zone4", "Zone5"],
]

@onready var zone_buttons: Array[ZoneButton] = [
	$Zones/Zone1 as ZoneButton,
	$Zones/Zone2 as ZoneButton,
	$Zones/Zone3 as ZoneButton,
	$Zones/Zone4 as ZoneButton,
	$Zones/Zone5 as ZoneButton,
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

func _on_zone_pressed(button: ZoneButton) -> void:
	_show_zone_info(button)
	enter_button.disabled = false

func _show_zone_info(button: ZoneButton) -> void:
	var zone := button.zone
	if zone == null:
		zone_name_label.text = button.text
		zone_level_label.text = "Nivel: —"
		zone_enemies_label.text = "Enemigos: —"
		return
	zone_name_label.text = zone.display_name
	zone_level_label.text = "Nivel: %d" % zone.level
	zone_enemies_label.text = "Enemigos: %d" % zone.enemy_count

func _on_enter_pressed() -> void:
	get_tree().change_scene_to_file(BATTLE_SCENE)

func _draw() -> void:
	for connection in ZONE_CONNECTIONS:
		var from := get_node("Zones/" + connection[0]) as Button
		var to := get_node("Zones/" + connection[1]) as Button
		draw_line(from.position + from.size * 0.5, to.position + to.size * 0.5, Color(0.35, 0.42, 0.55), 4.0)
