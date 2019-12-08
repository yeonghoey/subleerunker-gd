extends Control

onready var _frame: GameFrame = find_node("Frame")


func _ready():
	_display_mode_selection()


func _display_mode_selection():
	var view: Control = preload("res://game/view/mode_selection.tscn").instance()
	_frame.display(view)


func _unhandled_input(event):
#	if event.is_action_pressed("ui_cancel"):
#		Signals.emit_signal("scene_play_closed")
	pass