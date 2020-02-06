extends "res://scene/scene.gd"

signal backed()


onready var _Back: AudioStreamPlayer = $Audio/Back


func _ready():
	pass


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("backed")
		mark_closing()
		_Back.play()
		yield(_Back, "finished")
		close()
