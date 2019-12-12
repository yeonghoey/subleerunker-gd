extends "res://game/mover/mover.gd"
"""The base class of dropping objects like flames.
"""

# Ingame size
export(float) var width
export(float) var height

export(float) var acceleration_amount
export(float) var friction_amount
export(float) var max_speed

signal landed()


func init_within(boundary: Vector2) -> void:
	"""Place the drop in the top random of the boundary.
	
	This can be overriden if necessary.
	"""
	var x = (boundary.x - width*2) * randf() + width
	position = Vector2(x, -height)


func _physics_process(delta: float):
	var collision := move(delta)
	if collision:
		if collision.collider.is_in_group("Floor"):
			emit_signal("landed")
			queue_free()


func _acceleration() -> Vector2:
	return Vector2(0, acceleration_amount)


func _friction_amount() -> float:
	return friction_amount


func _max_speed() -> float:
	return max_speed