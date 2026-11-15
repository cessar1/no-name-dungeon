class_name PartyStatus extends PanelContainer

const MEMBER_STATUS_SCENE := preload("res://scenes/party_member_status.tscn")

@onready var members_container: HBoxContainer = %MembersContainer
@onready var energy_bar: TextureProgressBar = %MpBar
@onready var energy_value_label: Label = %EnergyValueLabel

# Crea siempre tres espacios de tarjeta y llena los que tienen miembro.
func setup_party(units: Array[BattleUnit]) -> void:
	_clear_members()

	for i in PartyState.MAX_MEMBERS:
		var card: PartyMemberStatus = MEMBER_STATUS_SCENE.instantiate()
		members_container.add_child(card)
		if i < units.size():
			card.setup(units[i], "Miembro %d" % (i + 1))
		else:
			card.show_empty()

func set_energy(current_energy: float, max_energy: float) -> void:
	energy_bar.max_value = max_energy
	energy_bar.value = current_energy
	energy_value_label.text = "%d / %d" % [int(current_energy), int(max_energy)]

func _clear_members() -> void:
	for child in members_container.get_children():
		members_container.remove_child(child)
		child.queue_free()
