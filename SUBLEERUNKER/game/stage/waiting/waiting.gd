extends "res://game/stage/stage.gd"

const Preset := preload("res://game/preset/preset.gd")

signal started()
signal canceled()

var _preset: Preset


func init(preset: Preset) -> void:
	_preset = preset


func _ready():
	_prepend_background()
	_override_labelcolor()


func _prepend_background():
	var background := _preset.make("Background")
	add_child(background)
	move_child(background, 0)


func _override_labelcolor():
	var labelcolor: Color = _preset.take("labelcolor")
	get_tree().call_group("GameLabel",
			"add_color_override", "font_color", labelcolor)


func _input(event):
	var start := (
		Input.is_action_pressed("ui_left") or
		Input.is_action_pressed("ui_right") or
		Input.is_action_pressed("ui_accept"))
	if start:
		emit_signal("started")
		return

	var cancel := (
		Input.is_action_pressed("ui_cancel"))
	if cancel:
		emit_signal("canceled")
		return