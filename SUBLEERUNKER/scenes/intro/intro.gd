extends Control


func _unhandled_input(event):
	if event.is_pressed():
		_end()


func _on_AnimationPlayer_animation_finished(anim_name):
	_end()


func _end():
	Signals.emit_signal("scene_intro_ended")