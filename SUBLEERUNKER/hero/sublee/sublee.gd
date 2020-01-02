extends "res://hero/hero.gd"

const BLINK_CONTINUANCE = 4

onready var _AnimationPlayer: AnimationPlayer = $AnimationPlayer
onready var _Body: Sprite = $Body
onready var _Head: Area2D = $Head
onready var _Eyelids: Sprite = $Eyelids
onready var _AudioRun: AudioStreamPlayer = $AudioRun

var _counter := 0


func _ready():
	connect("action_changed", self, "_on_action_changed")
	_Head.connect("area_entered", self, "_on_head_area_entered")


func _on_action_changed(prev_action, action):
	match [prev_action, action]:
		[ACTION_REST, ACTION_LEFT], [ACTION_REST, ACTION_RIGHT]:
			_AudioRun.play()
		[ACTION_LEFT, ACTION_REST], [ACTION_RIGHT, ACTION_REST]:
			_AudioRun.stop()


func _on_head_area_entered(area):
	hit()


func _process(delta):
	# Implement eye blinking
	_counter = (_counter + 1) % BLINK_CONTINUANCE
	if _counter == 0:
		if _Eyelids.visible:
			_Eyelids.visible = false
		else:
			_Eyelids.visible = randf() < 0.02


func _process_idle():
	_AnimationPlayer.play("idle")


func _process_left():
	_AnimationPlayer.play("run")
	_Body.flip_h = true
	_Eyelids.flip_h = true


func _process_right():
	_AnimationPlayer.play("run")
	_Body.flip_h = false
	_Eyelids.flip_h = false