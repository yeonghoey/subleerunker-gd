extends HBoxContainer

export(String) var key: String

var _style_selected: StyleBox = preload("selection.tres")
var _style_deselected: StyleBox = StyleBoxEmpty.new()


func set_onoff(b: bool):
	if b:
		$Value.text = "ON"
	else:
		$Value.text = "OFF"


func select():
	$Description.add_stylebox_override("normal", _style_selected)


func deselect():
	$Description.add_stylebox_override("normal", _style_deselected)