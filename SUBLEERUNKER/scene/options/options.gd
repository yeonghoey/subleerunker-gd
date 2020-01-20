extends "res://scene/scene.gd"

const Confbox := preload("res://box/confbox/confbox.gd")
const Item := preload("item.gd")

signal backed()

var _confbox: Confbox

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

onready var _Move: AudioStreamPlayer = $Move

var _selection := 0


func init(confbox: Confbox):
	_confbox = confbox


func _ready():
	for item in _layout:
		_show_conf(item)
	_move_selection(0)


func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		_move_selection(-1)
	if event.is_action_pressed("ui_down"):
		_move_selection(+1)

	if (event.is_action_pressed("ui_left") or
		event.is_action_pressed("ui_right") or
		event.is_action_pressed("ui_accept")):
		_flip_conf(_layout[_selection])

	if event.is_action_pressed("ui_cancel"):
		emit_signal("backed")
		close()


func _move_selection(di: int) -> void:
	var n: int = _layout.size()
	_layout[_selection].deselect()
	_selection = (_selection + di + n ) % n
	_layout[_selection].select()
	if di != 0:
		_Move.play()


func _show_conf(item: Item) -> void:
	var b = _confbox.ref()[item.key]
	item.set_onoff(b)


func _flip_conf(item: Item):
	var b = _confbox.ref()[item.key]
	_confbox.call("set_%s" % item.key, not b)
	_confbox.save()
	_show_conf(item)