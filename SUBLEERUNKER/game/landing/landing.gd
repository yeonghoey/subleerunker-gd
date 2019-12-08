extends Node2D

class_name GameLanding
"""GameLanding is the base class for landing effects of drops.
"""

signal finished()


func init(drop: GameDrop):
	position = drop.position


func finish():
	emit_signal("finished")
	queue_free()