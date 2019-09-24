tool
extends AnimationPlayer

class_name SpriteAnimator

export(Resource) var sprite_pack setget set_sprite_pack
export(NodePath) var animated_sprite_path setget set_animated_sprite_path
export(Array, String) var sprite_ids setget set_sprite_ids

func set_sprite_pack(pack: SpritePack):
	sprite_pack = pack
	_update_anims()

func set_animated_sprite_path(path: NodePath):
	animated_sprite_path = path
	_update_anims()

func set_sprite_ids(array: PoolStringArray):
	sprite_ids = array
	_update_anims()

func _ready():
	if Engine.editor_hint:
		_update_anims()

func _update_anims() -> void:
	# NOTE: This can be triggered when it's not ready,
	# speicifically when first loaded to the editor.
	# Just ignore it 
	if not is_inside_tree():
		return
	if animated_sprite_path == "":
		return
	if sprite_pack == null or not sprite_pack is SpritePack:
		return
	for id in sprite_ids:
		if not id in sprite_pack.catalog:
			push_warning("'%s' is not in the sprite pack" % id)
			continue
		_amend_animated_sprite(id)
		_amend_animation(id)

func _amend_animated_sprite(id: String):
	var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)
	if animated_sprite.frames == null:
		animated_sprite.frames = SpriteFrames.new()
	var sprframes = animated_sprite.frames
	if not sprframes.has_animation(id):
		sprframes.add_animation(id)
	sprframes.clear(id)
	for frame in sprite_pack.catalog[id]:
		sprframes.add_frame(id, frame["texture"])

func _amend_animation(id: String):
	var anim: Animation
	if has_animation(id):
		anim = get_animation(id)
	else:
		anim = Animation.new()
		add_animation(id, anim)
	_amend_animation_track(id, anim)
	_amend_frame_track(id, anim)

func _amend_animation_track(id: String, anim: Animation):
	var idx = _get_fresh_value_track(anim, "animation")
	anim.track_insert_key(idx, 0, id)

func _amend_frame_track(id: String, anim: Animation):
	var idx = _get_fresh_value_track(anim, "frame")
	var frames = sprite_pack.catalog[id]
	var time := 0.0
	for frame_idx in range(frames.size()):
		anim.track_insert_key(idx, time, frame_idx)
		var duration = frames[frame_idx]["duration"]
		time += duration / 1000
	anim.length = time

func _get_fresh_value_track(anim: Animation, property: String):
	var path = _track_path(property)
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

func _track_path(property: String):
	var root = get_node(root_node)
	var animated_sprite = get_node(animated_sprite_path)
	var path = root.get_path_to(animated_sprite)
	return NodePath("%s:%s" % [path, property])