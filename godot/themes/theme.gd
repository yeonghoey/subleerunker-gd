extends Node


var frames = {}

func _init(name: String):
	var atlas = load("res://themes/%s/atlas.png" % name)
	var meta = load_meta("res://themes/%s/atlas.json" % name)
	var kinds = build_kinds(meta["frames"])
	for kind in kinds:
		var framedata = kinds[kind]
		frames[kind] = []
		for fd in framedata:
			var x = fd["frame"]["x"]
			var y = fd["frame"]["y"]
			var w = fd["frame"]["w"]
			var h = fd["frame"]["h"]
			var duration = fd["duration"]
			var texture = AtlasTexture.new()
			texture.atlas = atlas
			texture.region = Rect2(x, y, w, h)
			frames[kind].append({"texture": texture, "duration": duration})

func load_meta(path: String):
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	var p = JSON.parse(content)
	assert p.error == OK
	return p.result

func build_kinds(frames):
	# Using `frames`, | {"{kind}-{frame_num}": {value}}
	# build `interim` | {"{kind}": [{frame_num}, {value}]}
	var interim = {}
	for key in frames:
		var value = frames[key]
		var parts = key.rsplit("-", true, 1)
		var kind = parts[0]
		var frame_num = int(parts[1])
		if not interim.has(kind):
			interim[kind] = []
		interim[kind].append([frame_num, value])

	# Sort the values of `interim` using {frame_num} and 
	# build `result` | {"{kind}": [{value}]}
	# from `interim`.
	var ret = {}
	for kind in interim:
		var kindframes = interim[kind]
		kindframes.sort_custom(Sorter, "comp")
		ret[kind] = []
		for kf in kindframes:
			var value = kf[1]
			ret[kind].append(value)
	return ret

class Sorter:
	static func comp(a, b):
		return a[0] < b[0]

func _ready():
	pass # Replace with function body.