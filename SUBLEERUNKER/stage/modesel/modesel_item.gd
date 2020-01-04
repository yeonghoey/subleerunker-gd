extends PanelContainer

const NORMAL := preload("modesel_item_normal.tres")
const SELECTED := preload("modesel_item_selected.tres")

var _name: String
var _icon: Texture

onready var _Icon: TextureRect = find_node("Icon")


func init(entry: Dictionary) -> void:
	# TODO: Check if the mode is unlocked
	_name = entry["name"]
	_icon = entry["icon"]


func _ready():
	_Icon.texture = _icon


func select():
	add_stylebox_override("panel", SELECTED)


func deselect():
	add_stylebox_override("panel", NORMAL)


func get_name() -> String:
	return _name