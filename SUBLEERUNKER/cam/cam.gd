extends Node2D
"""A Camera2D containing node which will be attached to InGame.

Subclasses can override `on_<sigal>` methods which will get called when
the signal emitted by the InGame.

Also, subclasses can make good use of `create_shake_animation`,
which will create camera shaking animation programatically.
"""


onready var _Camera2D := $Camera2D
onready var _AnimationPlayer := $AnimationPlayer


func create_shake_animation(name: String, duration: float, step: float, shake_amount: float) -> void:
	var animation := Animation.new()

	var rand_track := animation.add_track(Animation.TYPE_METHOD)
	var rand_key := {"method": "_rand_offset", "args": [shake_amount]}
	var t := 0.0
	while t < duration:
		animation.track_insert_key(rand_track, t, rand_key)
		t += step

	# NOTE: Reset the offset to (0, 0) at the end of the animation.
	# Add 0.1 to make sure float comparision issue doesn't affect
	var length := duration + 0.1
	var reset_track := animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(reset_track, "Camera2D:offset")
	animation.track_insert_key(reset_track, length, Vector2(0, 0))
	animation.length = length

	_AnimationPlayer.add_animation(name, animation)


func play(name: String) -> void:
	_AnimationPlayer.play(name)


func _rand_offset(shake_amount: float) -> void:
	_Camera2D.offset = Vector2(
	    rand_range(-1.0, 1.0) * shake_amount,
        rand_range(-1.0, 1.0) * shake_amount)


func on_started(initial_score: int, initial_n_combo: int) -> void:
	pass


func on_scored(score: int) -> void:
	pass


func on_combo_hit(n_combo: int) -> void:
	pass


func on_combo_missed(n_combo: int, last_n_combo: int) -> void:
	pass


func on_hero_hit(final_score: int) -> void:
	pass


func on_ended() -> void:
	pass