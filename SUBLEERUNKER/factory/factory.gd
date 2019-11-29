extends Reference

class_name Factory

const FIELDS: Array = [
	"hero",
	"drop", 
	"pedal",
]


static func of(mode_name: String) -> Factory:
	return load("res://factory/%s.gd" % mode_name).new()


var _preset: Dictionary = {}


func _init(preset: Dictionary):
	for f in FIELDS:
		assert(preset.has(f))
	_preset = preset


func make(name: String) -> Node:
	return _preset[name].instance()