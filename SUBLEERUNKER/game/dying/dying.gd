extends Node2D

class_name Dying
"""Dying is a base class for the hero dying animation.


The subclasses are responsible for emitting the 'finished' 
when it's finished.
"""

signal finished()


func init(where_hero_was: Vector2):
	position = where_hero_was


func _ready():
	connect("finished", self, "_on_finished")


func _on_finished():
	queue_free()