extends "res://pedalhitting/pedalhitting.gd"


func _ready():
	var label = $Label
	label.text = "x%d" % n_combo()
	# Make it centered
	var offset_x = label.rect_size.x / 2
	transform = transform.translated(Vector2(-offset_x, 0))
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")


func _on_animation_finished(anim_name):
	finish()
