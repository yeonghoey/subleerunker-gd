extends KinematicBody2D
"""The base class of moving objects in game.

Subclasses should implement virtual methods: 
'_acceleration', '_friction_amount', '_max_speed'.
All units here are per second. Subclasses should call 'move(delta)'
in their '_physics_process' to make the body actually move.
"""

const Z := Vector2(0.0, 0.0)

var _velocity := Z


func move(delta: float) -> KinematicCollision2D:
	_velocity = _next_velocity(delta)
	return move_and_collide(_velocity * delta)


func _next_velocity(delta: float) -> Vector2:
	var a := _acceleration() * delta
	var f := _velocity.normalized() * _friction_amount() * delta
	var x := _velocity + a - f
	# Zero set the velocity if the direction is completely changed
	# so that the movement looks consistent.
	if _velocity.dot(x) < 0:
		return Z
	return x.clamped(_max_speed())


# Virtual methods
func _acceleration() -> Vector2:
	# pixels/sec
	return Z


func _friction_amount() -> float:
	return 0.0


func _max_speed() -> float:
	return 0.0