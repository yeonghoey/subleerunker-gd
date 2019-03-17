extends "res://classes/mover.gd"

const W := 48.0
const H := 72.0
const FORCE := 60.0

enum {ACTION_IDLE, ACTION_LEFT, ACTION_RIGHT}

signal hit

var action = ACTION_IDLE
var turning = false

func _ready():
	$Head.connect("body_entered", self, "_on_Head_body_entered")

func _process(delta):
	update_action()
	update_animation()

func update_action():
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	match [action, turning, left, right]:
		[_, _, false, false]:
			action = ACTION_IDLE
			turning = false
		[_, _, true, false]:
			action = ACTION_LEFT
			turning = false
		[_, _, false, true]:
			action = ACTION_RIGHT
			turning = false
		[ACTION_LEFT, false, true, true]:
			action = ACTION_RIGHT
			turning = true
		[ACTION_RIGHT, false, true, true]:
			action = ACTION_LEFT
			turning = true

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

func _acceleration() -> Vector2:
	match action:
		ACTION_LEFT:
			return Vector2(-FORCE, 0)
		ACTION_RIGHT:
			return Vector2(FORCE, 0)
		_:
			return Vector2(0, 0)

func _friction() -> float:
	match action:
		ACTION_IDLE:
			return FORCE
		_:
			return 0.0

func _max_velocity() -> float:
	return 300.0

func _on_Head_body_entered(body):
	emit_signal("hit")
	queue_free()