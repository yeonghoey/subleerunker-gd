extends HBoxContainer

export(String) var key: String

const Options := preload("res://options/options.gd")

var _options: Options
var _style_selected: StyleBox = preload("selection.tres")
var _style_deselected: StyleBox = StyleBoxEmpty.new()


func init(options: Options) -> void:
	_options = options
	_update_value()


func _update_value():
	var value = _options.ref()[key]
	if value:
		$Value.text = "ON"
	else:
		$Value.text = "OFF"


func select():
	$Description.add_stylebox_override("normal", _style_selected)


func deselect():
	$Description.add_stylebox_override("normal", _style_deselected)


func flip():
	var value = _options.ref()[key]
	_options.call("set_%s" % key, not value)
	_options.save()
	_update_value()