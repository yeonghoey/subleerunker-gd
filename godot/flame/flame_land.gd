extends Node2D

func _ready():
	$SpriteAnimator.sprite_pack = load("res://sprite_packs/default/pack.tres")
	$SpriteAnimator.play("flame_land")
	$SpriteAnimator.connect("animation_finished", self, "_on_finished")

func _on_finished(anim: String):
	queue_free()