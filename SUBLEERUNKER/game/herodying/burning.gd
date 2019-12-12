extends "res://game/herodying/herodying.gd"


func _ready():
	$AnimatedSprite.connect("animation_finished", self, "finish")
	$AnimatedSprite.play("default")