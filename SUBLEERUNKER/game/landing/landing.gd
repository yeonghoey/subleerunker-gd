extends Node2D

class_name Landing
"""Landing is the base class for landing effects of drops.
"""

signal finished()


func init(drop: Drop):
	position = drop.position


func finish():
	emit_signal("finished")
	queue_free()