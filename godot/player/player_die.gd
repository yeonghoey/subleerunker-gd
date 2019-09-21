extends Node2D

func _ready():
	$SpriteAnimator.sprite_pack = load("res://sprite_packs/default/pack.tres")
	$SpriteAnimator.connect("animation_finished", self, "_on_finished")
	$SpriteAnimator.play("player_die")

func _on_finished(anim: String):
	queue_free()