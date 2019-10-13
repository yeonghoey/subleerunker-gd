extends Node2D

func _ready():
	$AnimatedSprite.play()
	$AnimatedSprite.connect("animation_finished", self, "_on_finished")

func _on_finished():
	queue_free()