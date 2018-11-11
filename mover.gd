extends KinematicBody2D

var velocity = Vector2()

func update_velocity():
	var acc = _acceleration()
	var fric = velocity.normalized() * _friction()
	velocity = (velocity + acc - fric).clamped(_max_velocity())

func acceleration():
	pass

func friction():
	pass

func max_velocity():
	pass