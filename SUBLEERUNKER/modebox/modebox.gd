extends "res://persistent_model/persistent_model.gd"

const Mode := preload("res://mode/mode.gd")

var _names := []
var _modes := {}


func filepath() -> String:
	return "user://modebox.json"


func _v1() -> Dictionary:
	return {
		last_modename = "",
	}


func _init(names: Array) -> void:
	assert(names.size() > 0)
	_names = names.duplicate(true)
	for name in _names:
		var mode = load("res://mode/%s/%s.gd" % [name, name]).new()
		_modes[name] = mode


func list() -> Array:
	var a := []
	for name in _names:
		a.append(_modes[name])
	return a


func select(name: String) -> Mode:
	dataref()["last_modename"] = name
	save()
	return _modes[name]


func get_last_mode() -> Mode:
	var last_modename: String = dataref()["last_modename"]
	if not _modes.has(last_modename):
		last_modename = _names[0]
	return select(last_modename)