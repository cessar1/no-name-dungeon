extends CanvasLayer
func _ready() -> void:
	GameManager.skill_points_changed.connect(_on_skill_points_changed)

func _on_skill_points_changed(value : int):
	$ScoreLabel.text = "Skill Points : " + str(value)
