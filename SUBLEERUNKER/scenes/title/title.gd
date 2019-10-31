extends Control

const _menu_labels = {}
const _menu_layout = [
	['play', 'vs'],
	['achievements', 'achievements'],
	['options', 'options'],
]

var _sel_x := 0
var _sel_y := 0
var _sel_style = preload("res://scenes/title/selection.tres")
var _sel_empty = StyleBoxEmpty.new()


func _ready():
	for label in get_tree().get_nodes_in_group("TitleMenuItems"):
		assert label is Label
		var key = label.name.to_lower()
		_menu_labels[key] = label
	_move_selection(0, 0)


func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		_move_selection(0, -1)
	if event.is_action_pressed("ui_right"):
		_move_selection(1, 0)
	if event.is_action_pressed("ui_down"):
		_move_selection(0, 1)
	if event.is_action_pressed("ui_left"):
		_move_selection(-1, 0)
	if event.is_action_pressed("ui_accept"):
		_run_selection()


func _move_selection(ox, oy):
	_deselect(_get_current_selection())
	_sel_y = int(clamp(_sel_y + oy, 0, _menu_layout.size()-1))
	_sel_x = int(clamp(_sel_x + ox, 0, _menu_layout[_sel_y].size()-1))
	_select(_get_current_selection())


func _deselect(key: String):
	var label = _menu_labels[key]
	label.add_stylebox_override("normal", _sel_empty)


func _select(key: String):
	var label = _menu_labels[key]
	label.add_stylebox_override("normal", _sel_style)


func _run_selection():
	var key = _get_current_selection()
	var signal_name = "scene_%s_selected" % key
	Signals.emit_signal(signal_name)


func _get_current_selection() -> String:
	return _menu_layout[_sel_y][_sel_x]