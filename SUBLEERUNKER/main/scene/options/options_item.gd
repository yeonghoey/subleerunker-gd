extends HBoxContainer

export(String) var key: String

const Core := preload("res://main/scene/options/options_core.gd")

var _core: Core
var _style_selected: StyleBox = preload("res://main/scene/options/options_selection.tres")
var _style_deselected: StyleBox = StyleBoxEmpty.new()


func init(core: Core):
	_core = core
	_update_value()


func _update_value():
	var value = _core.get_option(key)
	if value:
		$Value.text = "ON"
	else:
		$Value.text = "OFF"


func select():
	$Description.add_stylebox_override("normal", _style_selected)


func deselect():
	$Description.add_stylebox_override("normal", _style_deselected)


func flip():
	var value = _core.get_option(key)
	_core.set_option(key, not value)
	_update_value()