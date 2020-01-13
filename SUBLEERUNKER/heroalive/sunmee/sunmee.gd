extends "res://heroalive/heroalive.gd"

onready var _AnimationPlayer: AnimationPlayer = $AnimationPlayer
onready var _Body: Sprite = $Body


var _hit_color := "red"


func _on_Head_area_entered(area):
	if area.is_in_group("SubleeBlue"):
		_hit_color = "blue"
	queue_free()


func dyingmessage() -> String:
	return _hit_color


func _process_idle():
	_AnimationPlayer.play("idle")


func _process_left():
	_AnimationPlayer.play("run")
	_Body.flip_h = true


func _process_right():
	_AnimationPlayer.play("run")
	_Body.flip_h = false