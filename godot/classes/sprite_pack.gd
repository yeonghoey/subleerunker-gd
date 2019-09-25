extends Resource

class_name SpritePack

export(Dictionary) var catalog = {}


func compile(sheet: Texture, data: Dictionary):
	var frames_by_id: Dictionary = group_by_id(data["frames"])
	for id in frames_by_id:
		var frames = frames_by_id[id]
		catalog[id] = []
		for frame in frames:
			var x = frame["frame"]["x"]
			var y = frame["frame"]["y"]
			var w = frame["frame"]["w"]
			var h = frame["frame"]["h"]
			var duration = frame["duration"]
			var texture = AtlasTexture.new()
			texture.atlas = sheet
			texture.region = Rect2(x, y, w, h)
			catalog[id].append({
				"texture": texture, 
				"duration": duration
			})


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
		numframe_pair_by_id.sort_custom(Sorter, "comp")
		ret[id] = []
		for numframe in numframe_pair_by_id:
			var frame = numframe[1]
			ret[id].append(frame)
	return ret


class Sorter:
	static func comp(a, b):
		return a[0] < b[0]


func head(id: String) -> Texture:
	return catalog[id][0]["texture"]


func refurbish_sprite(sprite: Sprite, params: Dictionary):
	var id = params["catalog_id"]
	sprite.texture = catalog[id][0]["texture"]


func refurbish_animation(
		player: AnimationPlayer, 
		sprite: AnimatedSprite, 
		params: Dictionary):

	var root: Node = player.get_node(player.root_node)
	var path_to_sprite: NodePath = root.get_path_to(sprite)
	if not params["catalog_id"] in catalog:
		push_warning("'%s' is not in the sprite pack" % params["catalog_id"])
		return
	_amend_animated_sprite(sprite, params)
	_amend_animation(player, path_to_sprite, params)


func _amend_animated_sprite(sprite: AnimatedSprite, params: Dictionary):
	var id = params["catalog_id"]
	if sprite.frames == null:
		sprite.frames = SpriteFrames.new()
		# The automatically genereated animation "default" is not needed.
		sprite.frames.remove_animation("default")
	var sprframes = sprite.frames
	if not sprframes.has_animation(id):
		sprframes.add_animation(id)
	sprframes.clear(id)
	for frame in catalog[id]:
		sprframes.add_frame(id, frame["texture"])


func _amend_animation(player: AnimationPlayer, path_to_sprite: NodePath, params: Dictionary):
	var id = params["catalog_id"]
	var anim_name = params.get("anim_name", params["catalog_id"])
	var anim: Animation
	if player.has_animation(anim_name):
		anim = player.get_animation(anim_name)
	else:
		anim = Animation.new()
		player.add_animation(anim_name, anim)

	_amend_frame_track(anim, path_to_sprite, id)
	_amend_single_value_track(anim, path_to_sprite, "animation", id)
	if "loop" in params:
		anim.loop = params["loop"]	
	if "flip_h" in params:
		_amend_single_value_track(anim, path_to_sprite, "flip_h", params["flip_h"])
	if "flip_v" in params:
		_amend_single_value_track(anim, path_to_sprite, "flip_v", params["flip_v"])


func _amend_frame_track(anim: Animation, path_to_sprite: NodePath, id: String):
	var idx = _get_fresh_value_track(anim, path_to_sprite, "frame")
	var frames = catalog[id]
	var time := 0.0
	for frame_idx in range(frames.size()):
		anim.track_insert_key(idx, time, frame_idx)
		var duration = frames[frame_idx]["duration"]
		time += duration / 1000
	anim.length = time


func _amend_single_value_track(anim: Animation, path_to_sprite: NodePath, value_name: String, value):
	var idx = _get_fresh_value_track(anim, path_to_sprite, value_name)
	anim.track_insert_key(idx, 0, value)


func _get_fresh_value_track(anim: Animation, path_to_sprite: NodePath, property: String):
	var path = NodePath("%s:%s" % [path_to_sprite, property])
	var idx = anim.find_track(path)
	if idx == -1:
		idx = anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(idx, path)
		anim.value_track_set_update_mode(idx, Animation.UPDATE_DISCRETE)
	else:
		# Clear previous keys
		for key_idx in range(anim.track_get_key_count(idx)):
			anim.track_remove_key(idx, 0)
	return idx