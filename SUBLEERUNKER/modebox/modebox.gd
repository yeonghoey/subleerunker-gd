extends "res://storage/storage.gd"

const Mode := preload("res://mode/mode.gd")

var _names := []
var _modes := {}


func filepath() -> String:
	return "user://modebox.json"


func _v1() -> Dictionary:
	return {
		selected = "",
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


func select(name: String) -> void:
	ref()["selected"] = name


func get_selected() -> Mode:
	var selected: String = ref()["selected"]
	if not _modes.has(selected):
		select(_names[0])
		return get_selected()
	return _modes[selected]