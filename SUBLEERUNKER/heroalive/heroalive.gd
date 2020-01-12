extends "res://mover/mover.gd"
"""The base class of the alive player characters.

Parameters:
	- width: of desired ingame size
	- height: of desired ingame size
	- animation_player_path: NodePath to AnimationPlayer
		- The AnimationPlayer should contain animations named 'idle', 'left', right'

	Subclasses are responsible for freeing this when it determines the hero got hit.

	For Mover implementation,
	- acceleration_amount: float
	- friction_amount: float
	- max_speed: float

Signals:
	- action_changed
	- hit
"""

enum {
	ACTION_REST,
	ACTION_LEFT,
	ACTION_RIGHT,
}

# Ingame size
export(float) var width
export(float) var height

export(float) var acceleration_amount
export(float) var friction_amount
export(float) var max_speed

var _action := ACTION_REST
# For handling when LR keys are pressed simultaneously
var _action_overridden := false


func init(boundary: Vector2) -> void:
	"""Place the hero in the bottom center of the boundary.

	This can be overriden if necessary.
	Returns self so that this can be method-chained.
	"""
	position = Vector2(boundary.x/2, boundary.y - height/2)


func _input(event: InputEvent) -> void:
	"""In general, using _unhandled_input is a better fit for handling game inputs.
	However, there was an issue propagating _unhandled_input events to nodes
	under a Viewport. while it was fixed, but not released to 3.1.x
	https://github.com/godotengine/godot/issues/31802
	For now, using _input would just be okay, because SUBLEERUNKER
	won't use any GUI inputs.
	"""
	if event.is_action("ui_left") or event.is_action("ui_right"):
		var left := Input.is_action_pressed("ui_left")
		var right := Input.is_action_pressed("ui_right")
		_handle_action_input(left, right)
	if event.is_action("ui_cancel"):
		queue_free()


func _handle_action_input(left: bool, right: bool) -> void:
	var prev_action := _action
	match [_action, _action_overridden, left, right]:
		[_, _, false, false]:
			_action = ACTION_REST
			_action_overridden = false
		[_, _, true, false]:
			_action = ACTION_LEFT
			_action_overridden = false
		[_, _, false, true]:
			_action = ACTION_RIGHT
			_action_overridden = false
		[ACTION_LEFT, false, true, true]:
			_action = ACTION_RIGHT
			_action_overridden = true
		[ACTION_RIGHT, false, true, true]:
			_action = ACTION_LEFT
			_action_overridden = true
	if prev_action != _action:
		on_action_changed(prev_action, _action)


func on_action_changed(prev_action: int, action: int) -> void:
	"""Subclasses can override this for their specific implementation.
	"""
	pass


func _process(delta):
	match _action:
		ACTION_REST:
			_process_idle()
		ACTION_LEFT:
			_process_left()
		ACTION_RIGHT:
			_process_right()


func _process_idle():
	pass


func _process_left():
	pass


func _process_right():
	pass


func _physics_process(delta: float):
	move(delta)


# Implementation of Mover virtual methods
func _acceleration() -> Vector2:
	match _action:
		ACTION_LEFT:
			return Vector2(-acceleration_amount, 0.0)
		ACTION_RIGHT:
			return Vector2(acceleration_amount, 0.0)
		_:
			return Vector2(0.0, 0.0)


func _friction_amount() -> float:
	match _action:
		ACTION_REST:
			return friction_amount
		_:
			return 0.0


func _max_speed() -> float:
	return max_speed