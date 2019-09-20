tool
extends AnimationPlayer

class_name ySpriteAnimator

export(Resource) var sprite_pack
export(NodePath) var animated_sprite_path

# This should be at the bottom of exports
# so that it can trigger _update_anims after all other values initialized.
export(Array, String) var kinds setget set_kinds

func set_kinds(array: PoolStringArray):
	kinds = array
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
		push_warning("'animated_sprite_path' is not set")
		return
	if sprite_pack == null or not sprite_pack is ySpritePack:
		push_warning("'sprite_pack' is invalid")
		return

	for kind in kinds:
		if not kind in sprite_pack.data:
			continue
		_amend_animated_sprite(kind)
		_amend_animation(kind)

func _amend_animated_sprite(kind: String):
	var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)
	if animated_sprite.frames == null:
		animated_sprite.frames = SpriteFrames.new()
	var sprframes = animated_sprite.frames
	if not sprframes.has_animation(kind):
		sprframes.add_animation(kind)
	sprframes.clear(kind)
	for frame in sprite_pack.data[kind]:
		sprframes.add_frame(kind, frame["texture"])

func _amend_animation(kind: String):
	var anim: Animation
	if has_animation(kind):
		anim = get_animation(kind)
	else:
		anim = Animation.new()
		add_animation(kind, anim)
	_amend_animation_track(kind, anim)
	_amend_frame_track(kind, anim)

func _amend_animation_track(kind: String, anim: Animation):
	var idx = _get_fresh_value_track(anim, "animation")
	anim.track_insert_key(idx, 0, kind)

func _amend_frame_track(kind: String, anim: Animation):
	var idx = _get_fresh_value_track(anim, "frame")
	var frames = sprite_pack.data[kind]
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