extends "res://classes/mover.gd"

const W := 24.0
const H := 16.0

signal landed

func _physics_process(delta):
	update_velocity()
	var collision = move_and_collide(velocity)
	if collision:
		if collision.collider.is_in_group("Floor"):
			emit_signal("landed")
			queue_free()

func _acceleration():
	return Vector2(0, 0.1)

func _friction():
	return 0.0

func _max_velocity():
	return 10.0