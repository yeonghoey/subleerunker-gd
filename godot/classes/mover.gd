extends KinematicBody2D

var velocity := Vector2()

func update_velocity():
	var acc := _acceleration()
	var fric := velocity.normalized() * _friction()
	velocity = (velocity + acc - fric).clamped(_max_velocity())

# If you want to use:
# - move_and_collide(), it should be pixels/frame
# - move_and_slide(), it should be pixels/sec
func _acceleration() -> Vector2:
	return Vector2()

func _friction() -> float:
	return float()

func _max_velocity() -> float:
	return float()