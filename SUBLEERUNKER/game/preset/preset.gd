extends Reference

const FIELDS: Array = [
	"hero",
	"drop", 
	"pedal",
]

var _spec: Dictionary = {}


func _init(spec: Dictionary):
	for f in FIELDS:
		assert(spec.has(f))
	_spec = spec


func make(name: String) -> Node:
	return _spec[name].instance()


func take(name: String):
	return _spec[name]