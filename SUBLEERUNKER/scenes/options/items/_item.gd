extends HBoxContainer

export var key: String

var _selected = preload("res://scenes/options/selection.tres")
var _deselected = StyleBoxEmpty.new()

var _value = null


func _ready():
	Signals.connect("option_%s_updated" % key, self, "_on_option_updated")
	Signals.emit_signal("option_get_requested", key)


func _on_option_updated(value):
	_set_value(value)


func _set_value(value):
	_value = value
	if value:
		$Value.text = "ON"
	else:
		$Value.text = "OFF"


func select():
	$Description.add_stylebox_override("normal", _selected)


func deselect():
	$Description.add_stylebox_override("normal", _deselected)


func flip():
	if _value == null:
		return
	Signals.emit_signal("option_set_requested", key, not _value)