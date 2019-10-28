extends Control


func _ready():
	pass


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Signals.emit_signal("scene_vs_closed")