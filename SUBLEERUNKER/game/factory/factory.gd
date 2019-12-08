extends Reference

class_name GameFactory

const FIELDS: Array = [
	"hero",
	"drop", 
	"pedal",
]


static func of(mode_name: String) -> GameFactory:
	return load("res://game/factory/%s.gd" % mode_name).new()


var _preset: Dictionary = {}


func _init(preset: Dictionary):
	for f in FIELDS:
		assert(preset.has(f))
	_preset = preset


func make(name: String) -> Node:
	return _preset[name].instance()