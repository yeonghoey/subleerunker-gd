extends "res://pedalhitting/pedalhitting.gd"


var _combo: int


func init(combo: int) -> void:
	_combo = combo


func _ready():
	var label = $Label
	label.text = "x%d" % _combo
	# Make it centered
	var offset_x = label.rect_size.x / 2
	transform = transform.translated(Vector2(-offset_x, 0))
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")


func _on_animation_finished(anim_name):
	queue_free()
