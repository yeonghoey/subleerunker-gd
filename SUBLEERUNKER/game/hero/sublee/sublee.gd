extends "res://game/hero/hero.gd"

const BLINK_CONTINUANCE = 4

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _body: AnimatedSprite = $Body
onready var _eyelids: AnimatedSprite = $Eyelids
onready var _audio_run: AudioStreamPlayer = $AudioRun

var _counter := 0


func _ready():
	connect("action_changed", self, "_on_action_changed")


func _on_action_changed(prev_action, action):
	match [prev_action, action]:
		[ACTION_REST, ACTION_LEFT], [ACTION_REST, ACTION_RIGHT]:
			_audio_run.play()
		[ACTION_LEFT, ACTION_REST], [ACTION_RIGHT, ACTION_REST]:
			_audio_run.stop()


func _process(delta):
	# Implement eye blinking
	_counter = (_counter + 1) % BLINK_CONTINUANCE
	if _counter == 0:
		if _eyelids.visible:
			_eyelids.visible = false
		else:
			_eyelids.visible = randf() < 0.02


func _process_idle():
	_animation_player.play("idle")


func _process_left():
	_animation_player.play("run")
	_body.flip_h = true
	_eyelids.flip_h = true


func _process_right():
	_animation_player.play("run")
	_body.flip_h = false
	_eyelids.flip_h = false
