extends Camera2D

onready var _AnimationPlayer := $AnimationPlayer


func create_shake_animation(name: String, duration: float, step: float, shake_amount: float) -> void:
	var animation := Animation.new()
	var rand_track := animation.add_track(Animation.TYPE_METHOD)
	var rand_key := {"method": "_rand_offset", "args": [shake_amount]}
	var t := 0.0
	while t < duration:
		animation.track_insert_key(rand_track, t, rand_key)
		t += step
	var reset_track := animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(reset_track, ".:offset")
	animation.track_insert_key(reset_track, duration, Vector2(0, 0))
	_AnimationPlayer.add_animation(name, animation)


func play(name: String) -> void:
	_AnimationPlayer.play(name)


func _rand_offset(shake_amount: float) -> void:
	offset = Vector2(
	    rand_range(-1.0, 1.0) * shake_amount,
        rand_range(-1.0, 1.0) * shake_amount)
