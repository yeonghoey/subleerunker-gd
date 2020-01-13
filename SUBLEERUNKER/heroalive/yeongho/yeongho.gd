extends "res://heroalive/heroalive.gd"

onready var _AnimationPlayer: AnimationPlayer = $AnimationPlayer
onready var _Body: Sprite = $Body


func _on_Head_area_entered(area):
	queue_free()


func make_herodying() -> HeroDying:
	# TODO: Implement herodying for yeongho
	var herodying: HeroDying = preload("res://herodying/sublee/red.tscn").instance()
	herodying.position = position
	return herodying


func _process_idle():
	_AnimationPlayer.play("idle")


func _process_left():
	_AnimationPlayer.play("walk")
	_Body.flip_h = true


func _process_right():
	_AnimationPlayer.play("walk")
	_Body.flip_h = false