extends Reference


const SCHEMA: Dictionary = {
	name = TYPE_STRING,
	icon_on = Texture,
	icon_off = Texture,
	labelcolor = TYPE_COLOR,
	Background = PackedScene,
	Hero = PackedScene,
	DropSpawner = PackedScene,
	Pedal = PackedScene,
	PedalHitting = PackedScene,
	PedalMissing = PackedScene,
	PedalSpawner = PackedScene,
	BGM = PackedScene,
	Cam = PackedScene,
}

var _spec: Dictionary = {}

var name: String setget ,name_get


func name_get() -> String:
	return _spec["name"]


func _init(spec: Dictionary) -> void:
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


func take(key: String):
	return _spec[key]


func make(key: String) -> Node:
	var node: Node = _spec[key].instance()
	node.name = key
	return node