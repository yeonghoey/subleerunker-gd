extends "res://stage/stage.gd"

const Mode := preload("res://mode/mode.gd")
const Item := preload("res://stage/modesel/modesel_item.gd")
const Item_ := preload("res://stage/modesel/modesel_item.tscn")

signal selected(mode_name)
signal canceled()

var _selected_row := 0
var _selected_col := 0

onready var _Items: GridContainer = find_node("Items")


func init(last_mode: String) -> void:
	pass


func _ready():
	_refresh_icons()


func _refresh_icons():
	for item in _Items.get_children():
		item.queue_free()
	var mode := Mode.new()
	var specs := mode.compile()
	for spec in specs:
		var item := Item_.instance()
		item.init(spec)
		_Items.add_child(item)

	_get_selected_item().select()


func _input(event):
	if event.is_action_pressed("ui_up"):
		_move_selected_row(-1)
	if event.is_action_pressed("ui_right"):
		_move_selected_col(+1)
	if event.is_action_pressed("ui_down"):
		_move_selected_row(+1)
	if event.is_action_pressed("ui_left"):
		_move_selected_col(-1)

	if Input.is_action_pressed("ui_accept"):
		emit_signal("selected", _get_selected_item().name())
		return
	if Input.is_action_pressed("ui_cancel"):
		emit_signal("canceled")
		return


func _move_selected_row(d: int) -> void:
	_get_selected_item().deselect()
	var n := _Items.get_child_count()
	var c := _Items.columns
	var r := n / c
	var mr := (r) if _selected_col >= n%c else (r+1)
	_selected_row = (_selected_row + d + mr) % mr
	_get_selected_item().select()


func _move_selected_col(d: int) -> void:
	_get_selected_item().deselect()
	var n := _Items.get_child_count()
	var c := _Items.columns
	var r := n / c
	var mc := (c) if _selected_row < r else (n - r*c)
	_selected_col = (_selected_col + d + mc) % mc
	_get_selected_item().select()


func _get_selected_item() -> Item:
	var index := _get_selected_index()
	return _Items.get_child(index) as Item


func _get_selected_index() -> int:
	var num_cols := _Items.columns
	var index := (_selected_row * num_cols) + _selected_col
	return index % _Items.get_child_count()