extends Node

var signaled := false

func _unhandled_input(event):
	if signaled:
		return
	
	var pressed := (
		Input.is_action_pressed("ui_left") or 
		Input.is_action_pressed("ui_right"))

	if pressed:
		Signals.emit_signal("started")
		signaled = true
		queue_free()