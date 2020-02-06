extends "res://scene/scene.gd"

signal finished()


func _unhandled_input(event):
	if event.is_pressed():
		_finish()


func _on_AnimationPlayer_animation_finished(anim_name):
	_finish()


func _finish():
	emit_signal("finished")
	close()
