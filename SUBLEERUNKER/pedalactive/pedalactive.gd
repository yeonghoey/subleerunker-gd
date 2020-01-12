extends Area2D
"""The base class of pedals, which are for the combo system.

Subclasses should call two methods when:
	- trigger, when the hero triggered this
	- disappear, when running out of duration.
"""

const Hero := preload("res://hero/hero.gd")

export(float) var width
export(float) var height

var triggered := false


func init(boundary: Vector2, hero: Hero, hint = null) -> void:
	var x = (boundary.x - width*2) * randf() + width
	position = Vector2(x, boundary.y - height)


func trigger():
	triggered = true
	queue_free()


func disappear():
	queue_free()