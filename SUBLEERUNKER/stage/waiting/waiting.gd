extends "res://stage/stage.gd"

const Mode := preload("res://mode/mode.gd")

signal started()
signal canceled()

var _mode: Mode
var _modestat: Dictionary

onready var _BestScore := find_node("BestScore")


func init(mode: Mode, modestat: Dictionary) -> void:
	_mode = mode
	_modestat = modestat


func _ready():
	_set_bestscore()
	_prepend_background()
	_override_labelcolor()


func _set_bestscore():
	_BestScore.text = "%d" % _modestat["best_score"]


func _prepend_background():
	var background := _mode.make("Background")
	add_child(background)
	move_child(background, 0)


func _override_labelcolor():
	var labelcolor: Color = _mode.take("labelcolor")
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