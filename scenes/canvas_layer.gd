class_name BattleCanvasLayer extends CanvasLayer

@onready var battle_manager = $"../BattleManager"
@onready var party_status: PartyStatus = $PartyStatus

func _ready() -> void:
	battle_manager.party_energy.changed.connect(_on_party_energy_changed)

func setup_party(units: Array[BattleUnit]) -> void:
	party_status.setup_party(units)
	_on_party_energy_changed(battle_manager.party_energy.current_energy, battle_manager.party_energy.max_energy)

# La barra de MP es una sola para toda la party.
func _on_party_energy_changed(current_energy: float, max_energy: float) -> void:
	party_status.set_energy(current_energy, max_energy)
