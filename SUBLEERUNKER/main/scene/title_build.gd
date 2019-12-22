extends Label


func _ready():
	text = "Build: %s" % _build_id()


func _build_id():
	if ResourceLoader.exists("res://build_id.gd"):
		return load("res://build_id.gd").VALUE
	else:
		return "develop"