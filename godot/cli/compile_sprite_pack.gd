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
	var ret = ResourceSaver.save("res://%s" % kwargs["pack"], sprite_pack)
	assert ret == OK

func load_json(path: String) -> Dictionary:
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	var ret = JSON.parse(content)
	assert ret.error == OK
	return ret.result

func compile(sheet: Texture, data: Dictionary) -> SpritePack:
	var sprite_pack = SpritePack.new()
	var frames_by_id: Dictionary = group_by_id(data["frames"])
	for id in frames_by_id:
		var frames = frames_by_id[id]
		sprite_pack.data[id] = []
		for frame in frames:
			var x = frame["frame"]["x"]
			var y = frame["frame"]["y"]
			var w = frame["frame"]["w"]
			var h = frame["frame"]["h"]
			var duration = frame["duration"]
			var texture = AtlasTexture.new()
			texture.atlas = sheet
			texture.region = Rect2(x, y, w, h)
			sprite_pack.data[id].append({
				"texture": texture, 
				"duration": duration
			})
	return sprite_pack

func group_by_id(data: Dictionary) -> Dictionary:
	# Using `data`, which looks like {"{id}-{frame_num}": {value}},
	# build `interim`, which looks like  {"{id}": [{frame_num}, {value}]}
	var interim = {}
	for key in data:
		var value = data[key]
		var parts = key.rsplit(":", true, 1)
		var id = parts[0]
		var frame_num = int(parts[1])
		if not interim.has(id):
			interim[id] = []
		interim[id].append([frame_num, value])

	# Sort the values of `interim` using {frame_num} and 
	# build `result`, which looks like {"{id}": [{value}]},
	# from `interim`.
	var ret = {}
	for id in interim:
		var numframe_pair_by_id = interim[id]
		numframe_pair_by_id.sort_custom(Sorter, "comp")
		ret[id] = []
		for numframe in numframe_pair_by_id:
			var frame = numframe[1]
			ret[id].append(frame)
	return ret

class Sorter:
	static func comp(a, b):
		return a[0] < b[0]