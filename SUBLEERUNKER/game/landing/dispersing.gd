extends "res://game/landing/landing.gd"


func _ready():
	$AnimatedSprite.connect("animation_finished", self, "finish")
	$AnimatedSprite.play()