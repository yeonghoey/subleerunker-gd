extends Area2D
"""The base class of pedals, which are for the combo system.

Subclasses should call two methods when:
	- trigger, when the hero triggered this
	- disappear, when running out of duration.
"""

const PedalHitting := preload("res://pedalhitting/pedalhitting.gd")
const PedalMissing := preload("res://pedalmissing/pedalmissing.gd")

var triggered := false


func make_pedalhitting(combo: int) -> PedalHitting:
	assert(false) # Not implemented
	return null


func make_pedalmissing(last_combo: int) -> PedalMissing:
	assert(false) # Not implemented
	return null


func trigger():
	triggered = true
	queue_free()


func disappear():
	queue_free()