extends SceneTree

func _init():
	main()
	quit()

func main():
	var kwargs = {}
	for arg in OS.get_cmdline_args():
		var kv = arg.trim_prefix("--").split("=", true, 1)
		if kv.size() != 2:
			continue
		kwargs[kv[0]] = kv[1]

	var sheet = load("res://%s" % kwargs["sheet"])
	var data = load_json("res://%s" % kwargs["data"])
	var sprite_pack = compile(sheet, data)
	var ret = ResourceSaver.save("res://%s" % kwargs["tres"], sprite_pack)
	assert ret == OK

func load_json(path: String) -> Dictionary:
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	var ret = JSON.parse(content)
	assert ret.error == OK
	return ret.result

func compile(sheet: Texture, data: Dictionary) -> ySpritePack:
	var sprite_pack = ySpritePack.new()
	var frames_by_kind: Dictionary = group_by_kind(data["frames"])
	for kind in frames_by_kind:
		var frames = frames_by_kind[kind]
		sprite_pack.data[kind] = []
		for frame in frames:
			var x = frame["frame"]["x"]
			var y = frame["frame"]["y"]
			var w = frame["frame"]["w"]
			var h = frame["frame"]["h"]
			var duration = frame["duration"]
			var texture = AtlasTexture.new()
			texture.atlas = sheet
			texture.region = Rect2(x, y, w, h)
			sprite_pack.data[kind].append({
				"texture": texture, 
				"duration": duration
			})
	return sprite_pack

func group_by_kind(data: Dictionary) -> Dictionary:
	# Using `data`, which looks like {"{kind}-{frame_num}": {value}},
	# build `interim`, which looks like  {"{kind}": [{frame_num}, {value}]}
	var interim = {}
	for key in data:
		var value = data[key]
		var parts = key.rsplit("-", true, 1)
		var kind = parts[0]
		var frame_num = int(parts[1])
		if not interim.has(kind):
			interim[kind] = []
		interim[kind].append([frame_num, value])

	# Sort the values of `interim` using {frame_num} and 
	# build `result`, which looks like {"{kind}": [{value}]},
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