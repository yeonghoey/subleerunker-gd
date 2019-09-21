extends Node2D

func _ready():
	$ySpriteAnimator.sprite_pack = load("res://themes/default/atlas.tres")
	$ySpriteAnimator.connect("animation_finished", self, "_on_finished")
	$ySpriteAnimator.play("player-die")

func _on_finished(anim: String):
	queue_free()