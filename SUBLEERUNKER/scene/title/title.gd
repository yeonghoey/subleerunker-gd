extends "res://scene/scene.gd"

signal play_selected()
signal achievements_selected()
signal options_selected()

var _selection_index := 0
var _selection_style := preload("selection.tres")
var _selection_empty := StyleBoxEmpty.new()

onready var _menuitems = [
	{name='play', label=find_node("Play")},
	{name='achievements', label=find_node("Achievements")},
	{name='options', label=find_node("Options")},
]


onready var _Move: AudioStreamPlayer = $Audio/Move
onready var _Select: AudioStreamPlayer = $Audio/Select


func _ready():
	_move_selection(0)


func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		_move_selection(-1)
	if event.is_action_pressed("ui_down"):
		_move_selection(+1)
	if event.is_action_pressed("ui_accept"):
		_run_selection()


func _move_selection(di: int) -> void:
	var n: int = _menuitems.size()
	var selection_old: int = _selection_index
	var selection_new: int = (_selection_index + di + n) % n
	_deselect(selection_old)
	_select(selection_new)
	_selection_index = selection_new
	if di != 0:
		_Move.play()


func _deselect(idx: int) -> void:
	var label: Label = _menuitems[idx]["label"]
	label.add_stylebox_override("normal", _selection_empty)


func _select(idx: int) -> void:
	var label: Label = _menuitems[idx]["label"]
	label.add_stylebox_override("normal", _selection_style)


func _run_selection():
	var name: String = _menuitems[_selection_index]["name"]
	var signal_name = "%s_selected" % name
	emit_signal(signal_name)
	mark_closing()
	_Select.play()
	yield(_Select, "finished")
	close()