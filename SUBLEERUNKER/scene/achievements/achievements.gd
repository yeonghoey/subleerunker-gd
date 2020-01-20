extends "res://scene/scene.gd"

signal backed()


func _ready():
	pass


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("backed")
		close()