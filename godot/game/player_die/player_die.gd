extends Node2D

func _ready():
	$AnimatedSprite.connect("animation_finished", self, "_on_finished")
	$AnimatedSprite.play("default")

func _on_finished():
	queue_free()