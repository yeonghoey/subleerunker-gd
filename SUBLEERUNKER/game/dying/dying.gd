extends Node2D

class_name Dying
"""Dying is a base class for the hero dying animation.

The subclasses are responsible for calling 'finish'
when it's finished.
"""

signal finished()


func init(where_hero_was: Vector2):
	position = where_hero_was


func _ready():
	connect("finished", self, "_on_finished")


func finish():
	emit_signal("finished")
	queue_free()