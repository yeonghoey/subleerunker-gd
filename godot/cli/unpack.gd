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
	var base = "res://%s" % kwargs["base"]
	unpack(sheet, data, base)


func load_json(path: String) -> Dictionary:
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	var ret = JSON.parse(content)
	assert ret.error == OK
	return ret.result


func unpack(sheet: Texture, data: Dictionary, base: String):
	var frames_by_id: Dictionary = group_by_id(data["frames"])
	for id in frames_by_id:
		mkdirp("%s/%s" % [base, id])
		var frames: Array = frames_by_id[id]
		for idx in range(frames.size()):
			var frame = frames[idx]
			var x = frame["frame"]["x"]
			var y = frame["frame"]["y"]
			var w = frame["frame"]["w"]
			var h = frame["frame"]["h"]
			var texture = AtlasTexture.new()
			texture.atlas = sheet
			texture.region = Rect2(x, y, w, h)
			var path = "%s/%s/%02d.tres" % [base, id, idx]
			var ret = ResourceSaver.save(path, texture)
			assert ret == OK


func group_by_id(data: Dictionary) -> Dictionary:
	# Using `data`, which looks like {"{id}-{frame_num}": {value}},
	# build `interim`, which looks like  {"{id}": [{frame_num}, {value}]}
	var interim = {}
	for key in data:
		var value = data[key]
		var parts = key.rsplit(":", true, 1)
		# Remove trailing "_", for single tag sprites.
		var id = parts[0].trim_suffix("_")
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
		numframe_pair_by_id.sort_custom(self, "comp")
		ret[id] = []
		for numframe in numframe_pair_by_id:
			var frame = numframe[1]
			ret[id].append(frame)
	return ret


func comp(a, b):
	return a[0] < b[0]


func mkdirp(path: String):
	var d = Directory.new()
	var err = d.make_dir_recursive(path)
	assert err == OK