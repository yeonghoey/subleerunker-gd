extends Node2D

var signaled := false

func _ready():
	var pack = load("res://sprite_packs/default/pack.tres")
	$Logo.texture = pack.head("logo")
	$SpriteAnimator.sprite_pack = pack

func _unhandled_input(event):
	if signaled:
		return
	
	var pressed := (
		Input.is_action_pressed("ui_left") or 
		Input.is_action_pressed("ui_right"))

	if pressed:
		Signals.emit_signal("started")
		signaled = true
		queue_free()