extends "res://mover.gd"

export (int) var force = 60.0

enum {ACTION_IDLE, ACTION_LEFT, ACTION_RIGHT}

var action = ACTION_IDLE

func _ready():
	pass

func _process(delta):
	update_action()
	update_animation()

func update_action():
	if Input.is_action_pressed('ui_left'):
		action = ACTION_LEFT
	elif Input.is_action_pressed('ui_right'):
		action = ACTION_RIGHT
	else:
		action = ACTION_IDLE

func update_animation():
	match action:
		ACTION_IDLE:
			$AnimatedSprite.animation = "idle"
		ACTION_LEFT:
			$AnimatedSprite.animation = "run"
			$AnimatedSprite.flip_h = true
		ACTION_RIGHT:
			$AnimatedSprite.animation = "run"
			$AnimatedSprite.flip_h = false

func _physics_process(delta):
	update_velocity()
	move_and_slide(velocity)

func _acceleration():
	match action:
		ACTION_IDLE:
			return Vector2(0, 0)
		ACTION_LEFT:
			return Vector2(-force, 0)
		ACTION_RIGHT:
			return Vector2(force, 0)

func _friction():
	match action:
		ACTION_IDLE:
			return force
		_:
			return 0.0

func _max_velocity():
	return 300.0