extends Node

var viewport: Viewport
var signaled := false


func _ready():
	viewport.add_child(preload("res://game/background/default/background.tscn").instance())
	viewport.add_child(preload("view/view.tscn").instance())


func _unhandled_input(event):
	var pressed := (
		Input.is_action_pressed("ui_left") or 
		Input.is_action_pressed("ui_right"))

	if pressed and not signaled:
		Signals.emit_signal("started")
		signaled = true