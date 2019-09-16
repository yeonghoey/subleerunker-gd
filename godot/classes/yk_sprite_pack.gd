class_name ykSpritePack

static func compose(atlas_path: String, json_path: String) -> Dictionary:
	var atlas: Texture = load(atlas_path)
	var json: Dictionary = _load_json(json_path) as Dictionary
	var pack = {}
	var kinds: Dictionary = _build_kinds(json["frames"])
	for kind in kinds:
		var framedata = kinds[kind]
		pack[kind] = []
		for fd in framedata:
			var x = fd["frame"]["x"]
			var y = fd["frame"]["y"]
			var w = fd["frame"]["w"]
			var h = fd["frame"]["h"]
			var duration = fd["duration"]
			var texture = AtlasTexture.new()
			texture.atlas = atlas
			texture.region = Rect2(x, y, w, h)
			pack[kind].append({"texture": texture, "duration": duration})
	return pack

static func _load_json(path: String):
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	var p = JSON.parse(content)
	assert p.error == OK
	return p.result

static func _build_kinds(frames) -> Dictionary:
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