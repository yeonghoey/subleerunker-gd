extends "res://game/stage/stage.gd"

signal selected(mode_name)
signal canceled()


func _ready():
	pass


func _input(event):
	emit_signal("selected", "subleerunker")
	close()