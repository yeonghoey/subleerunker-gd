extends "res://mover/mover.gd"
"""The base class of dropping objects like flames.

IMPORTANT: Subclasses should free on its own when the drop hit the hero.
"""

const DropLanding := preload("res://droplanding/droplanding.gd")

export(float) var acceleration_amount
export(float) var friction_amount
export(float) var max_speed

# DropFalling can be removed when it landed to the floor
# or it hit the hero. `landed` is for distinguishing these two.
var landed := false


func make_droplanding() -> DropLanding:
	"""Subclasses are responsible for creating their DropLanding instances
	"""
	assert(false) # Not implemented
	return null


func _physics_process(delta: float):
	var collision := move(delta)
	if collision:
		if collision.collider.is_in_group("Floor"):
			landed = true
			queue_free()


func _acceleration() -> Vector2:
	return Vector2(0, acceleration_amount)


func _friction_amount() -> float:
	return friction_amount


func _max_speed() -> float:
	return max_speed