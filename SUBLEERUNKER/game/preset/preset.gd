extends Reference

const SCHEMA: Dictionary = {
	name = TYPE_STRING,
	labelcolor = TYPE_COLOR,

	Background = PackedScene,
	Hero = PackedScene,
	Drop = PackedScene,
	Pedal = PackedScene,
	Landing = PackedScene,
	Dying = PackedScene,
}

var _spec: Dictionary = {}


func _init(spec: Dictionary):
	for f in SCHEMA:
		assert(spec.has(f))
	for f in spec:
		assert(SCHEMA.has(f))
		var val = spec[f]
		var typ = SCHEMA[f]
		match typeof(typ):
			TYPE_OBJECT:
				assert(val is typ)
			_:
				assert(typeof(val) == typ)
	_spec = spec


func take(name: String):
	return _spec[name]


func make(name: String) -> Node:
	return _spec[name].instance()