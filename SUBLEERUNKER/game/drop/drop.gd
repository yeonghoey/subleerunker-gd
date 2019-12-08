extends GameMover

class_name GameDrop
"""GameDrop is the base class for dropping objects like flames.
"""

# Ingame size
export(float) var width
export(float) var height

export(float) var acceleration_amount
export(float) var friction_amount
export(float) var max_speed

signal landed()


func within(boundary: Vector2) -> GameDrop:
	"""Place the drop in the top random of the boundary.
	
	This can be overriden if necessary.
	Returns self so that this can be method-chained.
	"""
	var x = (boundary.x - width*2) * randf() + width
	position = Vector2(x, -height)
	return self


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