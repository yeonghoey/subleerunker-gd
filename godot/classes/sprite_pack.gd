extends Resource

class_name SpritePack

#warning-ignore:unused_class_variable
export(Dictionary) var data = {}

func head(id: String) -> Texture:
	return data[id][0]["texture"]

func render(
		player: AnimationPlayer, 
		sprite: AnimatedSprite, 
		sprite_ids: PoolStringArray):

	var root: Node = player.get_node(player.root_node)
	var path_to_sprite: NodePath = root.get_path_to(sprite)
	
	for id in sprite_ids:
		if not id in data:
			push_warning("'%s' is not in the sprite pack" % id)
			continue
		_amend_animated_sprite(sprite, id)
		_amend_animation(player, path_to_sprite, id)

func _amend_animated_sprite(sprite: AnimatedSprite, id: String):
	if sprite.frames == null:
		sprite.frames = SpriteFrames.new()
	var sprframes = sprite.frames
	if not sprframes.has_animation(id):
		sprframes.add_animation(id)
	sprframes.clear(id)
	for frame in data[id]:
		sprframes.add_frame(id, frame["texture"])

func _amend_animation(player: AnimationPlayer, path_to_sprite: NodePath, id: String):
	var anim: Animation
	if player.has_animation(id):
		anim = player.get_animation(id)
	else:
		anim = Animation.new()
		player.add_animation(id, anim)
	_amend_animation_track(anim, path_to_sprite, id)
	_amend_frame_track(anim, path_to_sprite, id)

func _amend_animation_track(anim: Animation, path_to_sprite: NodePath, id: String):
	var idx = _get_fresh_value_track(anim, path_to_sprite, "animation")
	anim.track_insert_key(idx, 0, id)

func _amend_frame_track(anim: Animation, path_to_sprite: NodePath, id: String):
	var idx = _get_fresh_value_track(anim, path_to_sprite, "frame")
	var frames = data[id]
	var time := 0.0
	for frame_idx in range(frames.size()):
		anim.track_insert_key(idx, time, frame_idx)
		var duration = frames[frame_idx]["duration"]
		time += duration / 1000
	anim.length = time

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