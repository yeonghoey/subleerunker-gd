extends Control

const packed_view = preload("view/view.tscn")

var viewport: Viewport

onready var signaled := false


func _ready():
	var view = packed_view.instance()
	viewport.add_child(view)


func _unhandled_input(event):
	var pressed := (
		Input.is_action_pressed("ui_left") or 
		Input.is_action_pressed("ui_right"))

	if pressed and not signaled:
		Signals.emit_signal("started")
		signaled = true