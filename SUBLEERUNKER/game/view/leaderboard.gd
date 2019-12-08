extends GameView

var _factory: GameFactory


func init(factory: GameFactory):
	_factory = factory


func _ready():
	# NOTE: This is for testing
	if _factory == null:
		_factory = GameFactory.of("subleerunker")
	_prepend_background()
	_ovrride_labelcolor()


func _prepend_background():
	var background := _factory.make("background")
	add_child(background)
	move_child(background, 0)

	
func _ovrride_labelcolor():
	var labelcolor: Color = _factory.take("labelcolor")
	for label in get_tree().get_nodes_in_group("GameLabel"):
		label.add_color_override("font_color", labelcolor)