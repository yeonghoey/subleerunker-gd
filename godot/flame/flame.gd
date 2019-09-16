extends ykMover

const W := 24.0
const H := 16.0

func _physics_process(delta):
	update_velocity()
	var collision = move_and_collide(velocity)
	if collision:
		if collision.collider.is_in_group("Floor"):
			Signals.emit_signal("landed", self)
			queue_free()

func _acceleration():
	return Vector2(0, 0.1)

func _friction():
	return 0.0

func _max_velocity():
	return 10.0