class_name PartyMemberStatus extends PanelContainer

@onready var portrait: TextureRect = %Portrait
@onready var name_label: Label = %NameLabel
@onready var hp_label: Label = %HpLabel
@onready var hp_bar: TextureProgressBar = %HpBar

# Inicializa la tarjeta con los datos del miembro y queda escuchando su HP.
func setup(unit: BattleUnit, display_name: String) -> void:
	portrait.visible = true
	name_label.text = display_name
	hp_bar.max_value = unit.max_hp
	_set_hp(unit, unit.current_hp)
	unit.unit_hp_changed.connect(_on_hp_changed)

# Reserva el espacio de la tarjeta cuando todavía no hay miembro.
func show_empty() -> void:
	portrait.visible = false
	name_label.text = ""
	hp_label.text = ""
	hp_bar.max_value = 1.0
	hp_bar.value = 0.0

func _on_hp_changed(unit: BattleUnit, current_hp: float) -> void:
	_set_hp(unit, current_hp)

func _set_hp(unit: BattleUnit, current_hp: float) -> void:
	var clamped_hp := maxf(current_hp, 0.0)
	hp_bar.value = clamped_hp
	hp_label.text = "HP %d / %d" % [int(clamped_hp), int(unit.max_hp)]
