extends "res://game/stage/stage.gd"


func _init(n: int):
	var l := Label.new()
	l.text = "%d" % n
	add_child(l)