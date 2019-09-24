extends Node2D

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_finished")

func _on_finished(anim: String):
	queue_free()