extends CanvasLayer

@onready var battle_manager = $"../BattleManager"
@onready var character_status: CharacterStatus = $CharacterStatus

var tracked_unit: BattleUnit

func _ready() -> void:
	battle_manager.player_selected.connect(_on_player_selected)

func _on_player_selected(unit: BattleUnit):
	print("Selected")
	if tracked_unit:
		if tracked_unit.unit_energy_changed.is_connected(_on_energy_changed):
			tracked_unit.unit_energy_changed.disconnect(_on_energy_changed)
		if tracked_unit.unit_hp_changed.is_connected(_on_hp_changed):
			tracked_unit.unit_hp_changed.disconnect(_on_hp_changed)

	tracked_unit = unit
	unit.unit_energy_changed.connect(_on_energy_changed)
	unit.unit_hp_changed.connect(_on_hp_changed)
	_on_energy_changed(unit, unit.current_energy, unit.max_energy)
	_on_hp_changed(unit, unit.current_hp)

func _on_energy_changed(_unit: BattleUnit, current_energy: float, max_energy: float):
	character_status.set_energy(current_energy, max_energy)

func _on_hp_changed(unit: BattleUnit, current_hp: float):
	character_status.set_hp(current_hp, unit.max_hp)
