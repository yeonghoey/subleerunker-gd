tool
extends AnimatedSprite

export(String, FILE, "*.png") var atlas_image
export(String, FILE, "*.json") var atlas_data
export(Array, String) var kinds
class_name ykAnimatedSprite

var animated_sprite: AnimatedSprite
var animation_player: AnimationPlayer

func _init(sprite_pack: Dictionary, blueprints: Array):
	name = "ykAnimatedSprite"
	_init_animated_sprite(sprite_pack, blueprints)

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