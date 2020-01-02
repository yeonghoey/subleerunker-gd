extends PanelContainer

const NORMAL := preload("modesel_item_normal.tres")
const SELECTED := preload("modesel_item_selected.tres")

var _spec := {}

onready var _Icon: TextureRect = find_node("Icon")


func init(spec: Dictionary) -> void:
	_spec = spec


func _ready():
	_Icon.texture = _spec["icon_on"]


func select():
	add_stylebox_override("panel", SELECTED)


func deselect():
	add_stylebox_override("panel", NORMAL)


func name() -> String:
	return _spec["name"]