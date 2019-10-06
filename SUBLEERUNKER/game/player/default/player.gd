extends "res://game/player/player.gd"

const BLINK_CONTINUANCE = 4

onready var body: AnimatedSprite = $Body
onready var eyelids: AnimatedSprite = $Eyelids

var counter := 0

func _process(delta):
	# Implement eye blinking
	eyelids.frame = body.frame
	counter = (counter + 1) % BLINK_CONTINUANCE
	if counter == 0:
		if eyelids.visible:
			eyelids.visible = false
		else:
			eyelids.visible = randf() < 0.02