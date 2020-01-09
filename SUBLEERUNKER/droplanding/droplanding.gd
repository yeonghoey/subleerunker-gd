extends Node2D
"""The base class of landing effects of drops.
"""

const DropFalling := preload("res://dropfalling/dropfalling.gd")


func init(dropfalling: DropFalling) -> void:
	position = dropfalling.position


func finish() -> void:
	queue_free()