extends PanelContainer

const Mode := preload("res://mode/mode.gd")

const NORMAL := preload("modesel_item_normal.tres")
const SELECTED := preload("modesel_item_selected.tres")

var _name: String
var _icon_on: Texture
var _icon_off: Texture

onready var _Icon: TextureRect = find_node("Icon")


func init(mode: Mode) -> void:
	# TODO: Check if the mode is unlocked
	_name = mode.take("name")
	_icon_on = mode.take("icon_on")
	_icon_off = mode.take("icon_off")


func _ready():
	_Icon.texture = _icon_on


func select():
	add_stylebox_override("panel", SELECTED)


func deselect():
	add_stylebox_override("panel", NORMAL)


func get_name() -> String:
	return _name