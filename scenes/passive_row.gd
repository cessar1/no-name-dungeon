class_name PassiveRow extends HBoxContainer

signal learn_requested(passive: PassiveSkill)

@onready var _name_label: Label = %NameLabel
@onready var _description_label: Label = %DescriptionLabel
@onready var _learn_button: Button = %LearnButton

var _passive: PassiveSkill

func _ready() -> void:
	_learn_button.pressed.connect(_on_learn_button_pressed)

func setup(passive: PassiveSkill) -> void:
	_passive = passive
	_name_label.text = "%s (%d punto%s)" % [
		passive.passive_name,
		passive.cost,
		"" if passive.cost == 1 else "s",
	]
	_description_label.text = passive.description

func update_state(learned: bool, points: int) -> void:
	_learn_button.text = "Aprendida" if learned else "Aprender"
	_learn_button.disabled = learned or points < _passive.cost

func _on_learn_button_pressed() -> void:
	learn_requested.emit(_passive)
