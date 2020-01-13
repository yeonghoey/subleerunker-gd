extends Area2D
"""The base class of pedals, which are for the combo system.

Subclasses should call two methods when:
	- trigger, when the hero triggered this
	- disappear, when running out of duration.
"""

var triggered := false


func trigger():
	triggered = true
	queue_free()


func disappear():
	queue_free()