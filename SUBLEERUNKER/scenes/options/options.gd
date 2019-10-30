extends Control

onready var _items = find_node("Items")
onready var _item_fullscreen = _items.get_node("FullScreen") 
onready var _item_hidecursor = _items.get_node("HideCursor")
onready var _item_music = _items.get_node("Music")
onready var _item_sound = _items.get_node("Sound")
onready var _layout = [
	_item_fullscreen,
	_item_hidecursor,
	_item_music,
	_item_sound,
]

var _sel := 0


func _ready():
	_move_selection(_sel)


func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		_move_selection(-1)
	if event.is_action_pressed("ui_down"):
		_move_selection(+1)

	if event.is_action_pressed("ui_right"):
		_get_current_selection().flip()
	if event.is_action_pressed("ui_left"):
		_get_current_selection().flip()
	if event.is_action_pressed("ui_accept"):
		_get_current_selection().flip()

	if event.is_action_pressed("ui_cancel"):
		Signals.emit_signal("scene_options_closed")


func _move_selection(d):
	_get_current_selection().deselect()
	_sel = int(clamp(_sel + d, 0, _layout.size()-1))
	_get_current_selection().select()


func _get_current_selection():
	return _layout[_sel]
