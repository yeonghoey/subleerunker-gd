extends GameView

var _preset: GamePreset


func init(preset: GamePreset):
	_preset = preset


func _ready():
	# NOTE: This is for testing
	if _preset == null:
		_preset = GamePreset.of("subleerunker")
	_prepend_background()
	_ovrride_labelcolor()


func _prepend_background():
	var background := _preset.make("background")
	add_child(background)
	move_child(background, 0)

	
func _ovrride_labelcolor():
	var labelcolor: Color = _preset.take("labelcolor")
	for label in get_tree().get_nodes_in_group("GameLabel"):
		label.add_color_override("font_color", labelcolor)