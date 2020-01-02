extends "res://scene/scene.gd"

const Core := preload("res://scene/options/options_core.gd")
const Item := preload("res://scene/options/options_item.gd")

signal backed()

var _core: Core

onready var _Items = find_node("Items")
onready var _FullScreen: Item = _Items.get_node("FullScreen")
onready var _HideCursor: Item = _Items.get_node("HideCursor")
onready var _Music: Item = _Items.get_node("Music")
onready var _Sound: Item = _Items.get_node("Sound")

onready var _layout = [
	_FullScreen,
	_HideCursor,
	_Music,
	_Sound,
]

var _selection := 0


func init():
	_core = Core.new()
	_core.load_last()


func _ready():
	for item in _layout:
		item.init(_core)
	_move_selection(_selection)


func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		_move_selection(-1)
	if event.is_action_pressed("ui_down"):
		_move_selection(+1)

	if event.is_action_pressed("ui_right"):
		_layout[_selection].flip()
	if event.is_action_pressed("ui_left"):
		_layout[_selection].flip()
	if event.is_action_pressed("ui_accept"):
		_layout[_selection].flip()

	if event.is_action_pressed("ui_cancel"):
		emit_signal("backed")


func _move_selection(di: int) -> void:
	var n: int = _layout.size()
	_layout[_selection].deselect()
	_selection = (_selection + di + n ) % n
	_layout[_selection].select()