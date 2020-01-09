extends "res://mover/mover.gd"
"""The base class of dropping objects like flames.
"""

const Hero := preload("res://hero/hero.gd")

# Ingame size
export(float) var width
export(float) var height

export(float) var acceleration_amount
export(float) var friction_amount
export(float) var max_speed

signal landed()


func init(boundary: Vector2, hero: Hero, hint = null) -> void:
	"""This will be called when a Spanwer decided to create this.

	'boundary' represents the size of the game area and
	'hero' is the hero which the player controls.
	'hint' will be an arbitrary parameter of the hint.
	"""
	pass


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