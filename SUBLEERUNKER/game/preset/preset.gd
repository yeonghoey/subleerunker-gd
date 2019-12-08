extends Reference

class_name GamePreset

const FIELDS: Array = [
	"hero",
	"drop", 
	"pedal",
]


static func of(mode_name: String) -> GamePreset:
	return load("res://game/preset/%s.gd" % mode_name).new()


var _spec: Dictionary = {}


func _init(spec: Dictionary):
	for f in FIELDS:
		assert(spec.has(f))
	_spec = spec


func make(name: String) -> Node:
	return _spec[name].instance()


func take(name: String):
	return _spec[name]