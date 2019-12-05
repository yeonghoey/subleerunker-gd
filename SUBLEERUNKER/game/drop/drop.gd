extends Mover

class_name Drop
"""Drop is the base class for dropping objects like flames.
"""

# Ingame size
export(float) var width
export(float) var height

export(float) var acceleration_amount
export(float) var friction_amount
export(float) var max_speed

signal landed()


func init(initial_pos: Vector2):
	position = initial_pos


func _physics_process(delta: float):
	var collision := move(delta)
	if collision:
		if collision.collider.is_in_group("Floor"):
			emit_signal("landed")
			queue_free()


func _acceleration():
	return Vector2(0, acceleration_amount)


func _friction_amount():
	return friction_amount


func _max_speed():
	return max_speed