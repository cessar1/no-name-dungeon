class_name CharacterStatus extends PanelContainer

@onready var hp_bar: TextureProgressBar = %HpBar
@onready var energy_bar: TextureProgressBar = %MpBar

func set_hp(current_hp: float, max_hp: float) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp

func set_energy(current_energy: float, max_energy: float) -> void:
	energy_bar.max_value = max_energy
	energy_bar.value = current_energy
