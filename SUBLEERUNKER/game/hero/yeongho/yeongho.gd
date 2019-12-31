extends "res://game/hero/hero.gd"

const BLINK_CONTINUANCE = 4

onready var _AnimationPlayer: AnimationPlayer = $AnimationPlayer
onready var _Body: Sprite = $Body
onready var _Head: Area2D = $Head

var _counter := 0


func _on_Head_area_entered(area):
	hit()


func _process_idle():
	_AnimationPlayer.play("idle")


func _process_left():
	_AnimationPlayer.play("walk")
	_Body.flip_h = true


func _process_right():
	_AnimationPlayer.play("walk")
	_Body.flip_h = false