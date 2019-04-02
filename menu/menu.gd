extends Node

signal pressed

var signaled := false

func _unhandled_input(event):
	if signaled:
		return
	
	var pressed := (
		Input.is_action_pressed("ui_left") or 
		Input.is_action_pressed("ui_right"))

	if pressed:
		emit_signal("pressed")
		signaled = true
		queue_free()