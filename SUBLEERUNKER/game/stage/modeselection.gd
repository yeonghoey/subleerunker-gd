extends "res://game/stage/stage.gd"

signal selected(mode_name)
signal canceled()


func init(last_mode: String) -> void:
	pass


func _ready():
	pass


func _input(event):
	if Input.is_action_pressed("ui_accept"):
		# TODO: send the selected mode.
		emit_signal("selected", "subleerunker")
		close()
		return
		
	if Input.is_action_pressed("ui_cancel"):
		emit_signal("canceled")
		close()
		return