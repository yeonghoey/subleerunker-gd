extends "res://heroalive/heroalive.gd"

onready var _AnimationPlayer: AnimationPlayer = $AnimationPlayer
onready var _Body: Sprite = $Body


var _hit_color := "red"


func _on_Head_area_entered(area):
	if area.is_in_group("green"):
		_hit_color = "green"
	if area.is_in_group("blue"):
		_hit_color = "blue"
	queue_free()


func make_herodying() -> HeroDying:
	var packed_scene: PackedScene
	match _hit_color:
		"green":
			packed_scene = preload("res://herodying/sublee/green.tscn")
		"blue":
			packed_scene = preload("res://herodying/sublee/blue.tscn")
		_:
			packed_scene = preload("res://herodying/sublee/red.tscn")
	var herodying: HeroDying = packed_scene.instance()
	herodying.position = position
	return herodying


func _process_idle():
	_AnimationPlayer.play("idle")


func _process_left():
	_AnimationPlayer.play("run")
	_Body.flip_h = true


func _process_right():
	_AnimationPlayer.play("run")
	_Body.flip_h = false