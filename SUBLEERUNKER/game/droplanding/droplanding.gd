extends Node2D
"""The base class of landing effects of drops.
"""

const Drop := preload("res://game/drop/drop.gd")


func init(drop: Drop) -> void:
	position = drop.position


func finish() -> void:
	queue_free()