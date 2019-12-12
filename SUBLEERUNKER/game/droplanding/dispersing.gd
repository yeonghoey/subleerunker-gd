extends "res://game/droplanding/droplanding.gd"


func _ready():
	$AnimatedSprite.connect("animation_finished", self, "finish")
	$AnimatedSprite.play()