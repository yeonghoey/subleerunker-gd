extends "res://game/herodying/herodying.gd"


func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")


func _on_animation_finished(anim_name: String) -> void:
	finish()