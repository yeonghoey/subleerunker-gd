extends "res://game/dying/dying.gd"


func _ready():
	$AnimatedSprite.connect("animation_finished", self, "finish")
	$AnimatedSprite.play("default")