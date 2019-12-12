extends Node2D
"""The base class of landing effects of drops.
"""

const Drop := preload("res://game/drop/drop.gd")

signal finished()


func init(drop: Drop) -> void:
	position = drop.position


func finish() -> void:
	emit_signal("finished")
	queue_free()