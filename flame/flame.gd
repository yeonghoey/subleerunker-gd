extends "res://mover.gd"

var W = 24
var H = 16

func _ready():
	pass

func _physics_process(delta):
	update_velocity()
	move_and_slide(velocity)

func _acceleration():
	return Vector2(0, 6)

func _friction():
	return 0.0

func _max_velocity():
	return 600.0