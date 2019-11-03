extends Node2D


var _n_combo = 0


func init(n_combo: int):
	_n_combo = n_combo


func _ready():
	var label = $Label
	label.text = "x%d" % _n_combo
	# Make it centered
	var offset_x = label.rect_size.x / 2
	transform = transform.translated(Vector2(-offset_x, 0))


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()