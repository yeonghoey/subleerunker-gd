extends Control


signal ended


func _unhandled_input(event):
	end()


func _on_AnimationPlayer_animation_finished(anim_name):
	end()


func end():
	emit_signal("ended")