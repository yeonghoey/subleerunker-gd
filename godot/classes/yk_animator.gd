tool
extends AnimationPlayer

class_name ykAnimator

export(Texture) var atlas
export(String, FILE, "*.json") var atlas_data
export(NodePath) var animated_sprite_path
export(Array, String) var kinds = []

func _ready():
	_update_anims()

func _update_anims() -> void:
	if atlas == null:
		push_warning("'atlas' is invalid")
		return
	if atlas_data == null:
		push_warning("'atlas_data' is invalid")
		return
	if animated_sprite_path == null:
		push_warning("'animated_sprite_path' is invalid")
		return
	var pack = _load_pack()
	for kind in kinds:
		_amend_animated_sprite(pack, kind)
		_amend_animation(pack, kind)

func _amend_animated_sprite(pack: Dictionary, kind: String):
	var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)
	if animated_sprite.frames == null:
		animated_sprite.frames = SpriteFrames.new()	
	var sprframes = animated_sprite.frames
	if not sprframes.has_animation(kind):
		sprframes.add_animation(kind)
	sprframes.clear(kind)
	for frame in pack[kind]:
		sprframes.add_frame(kind, frame["texture"])

func _amend_animation(pack: Dictionary, kind: String):
	var anim = get_animation(kind)
	if anim == null:
		anim = Animation.new()
		add_animation(kind, anim)
	_amend_animation_track(kind, anim)
	_amend_frame_track(pack, kind, anim)

func _amend_animation_track(kind: String, anim: Animation):
	var idx = _get_fresh_value_track(anim, "animation")
	anim.track_insert_key(idx, 0, kind)

func _amend_frame_track(pack: Dictionary, kind: String, anim: Animation):
	var idx = _get_fresh_value_track(anim, "frame")
	var frames = pack[kind]
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

func _load_pack() -> Dictionary:
	return ykSpritePack.compose(atlas, atlas_data)