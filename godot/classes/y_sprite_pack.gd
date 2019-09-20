tool
extends Resource

class_name ySpritePack

export(Texture) var atlas setget set_atlas
export(String, FILE, "*.json") var json setget set_json
export(Dictionary) var data setget set_data

func set_atlas(texture: Texture):
	atlas = texture
	_update()

func set_json(path: String):
	json = path
	_update()

func set_data(dict: Dictionary):
	push_error("Updating ySpritePack.data directly is not allowed.")
	return

func _update():
	if not Engine.editor_hint:
		return
	if not atlas:
		return
	if not json:
		return
	data = {}
	var body: Dictionary = _load_json() as Dictionary
	var kinds: Dictionary = _build_kinds(body["frames"])
	for kind in kinds:
		var framedata = kinds[kind]
		data[kind] = []
		for fd in framedata:
			var x = fd["frame"]["x"]
			var y = fd["frame"]["y"]
			var w = fd["frame"]["w"]
			var h = fd["frame"]["h"]
			var duration = fd["duration"]
			var texture = AtlasTexture.new()
			texture.atlas = atlas
			texture.region = Rect2(x, y, w, h)
			data[kind].append({"texture": texture, "duration": duration})

func _load_json():
	var f = File.new()
	f.open(json, File.READ)
	var content = f.get_as_text()
	f.close()
	var r = JSON.parse(content)
	assert r.error == OK
	return r.result

func _build_kinds(frames) -> Dictionary:
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