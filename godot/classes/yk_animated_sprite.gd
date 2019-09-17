extends Node2D

class_name ykAnimatedSprite

var animated_sprite: AnimatedSprite
var animation_player: AnimationPlayer

func _init(sprite_pack: Dictionary, blueprints: Array):
	name = "ykAnimatedSprite"
	_init_animated_sprite(sprite_pack, blueprints)
	_init_animation_player(sprite_pack, blueprints)

func _init_animated_sprite(sprite_pack: Dictionary, blueprints: Array) -> void:
	animated_sprite = AnimatedSprite.new()
	add_child(animated_sprite, true)
	animated_sprite.owner = self

	animated_sprite.frames = SpriteFrames.new()
	for blueprint in blueprints:
		var kind = blueprint["kind"]
		animated_sprite.frames.add_animation(kind)
		for frame in sprite_pack[kind]:
			animated_sprite.frames.add_frame(kind, frame["texture"])

func _init_animation_player(sprite_pack: Dictionary, blueprints: Array) -> void:
	animation_player = AnimationPlayer.new()
	add_child(animation_player, true)
	animation_player.owner = self

	for blueprint in blueprints:
		var kind = blueprint["kind"]
		var loop = blueprint["loop"]
		var animation = Animation.new()
		animation.loop = loop
		_add_anim_track(animation, kind)
		_add_frame_track(animation, sprite_pack[kind])
		animation_player.add_animation(kind, animation)

func _add_anim_track(animation: Animation, kind: String):
	var track_idx = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_idx, "%s:animation" % animated_sprite.name)
	animation.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
	animation.track_insert_key(track_idx, 0, kind)

func _add_frame_track(animation: Animation, frames):
	var track_idx = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_idx, "%s:frame" % animated_sprite.name)
	animation.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
	var time := 0.0
	for frame_idx in range(frames.size()):
		animation.track_insert_key(track_idx, time, frame_idx)
		var duration = frames[frame_idx]["duration"]
		time += duration / 1000
	animation.length = time