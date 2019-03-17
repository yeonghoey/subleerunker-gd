extends Node

signal pressed

func _process(delta):
	if (Input.is_action_pressed("ui_left") or
		Input.is_action_pressed("ui_right")):
		emit_signal("pressed")
		queue_free()