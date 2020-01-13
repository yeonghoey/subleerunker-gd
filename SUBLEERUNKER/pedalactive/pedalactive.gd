extends Area2D
"""The base class of pedals, which are for the combo system.

Subclasses should call two methods when:
	- hit, when the hero triggered this
	- miss, when running out of duration.
"""

const PedalHitting := preload("res://pedalhitting/pedalhitting.gd")
const PedalMissing := preload("res://pedalmissing/pedalmissing.gd")

var is_hit := false


func make_pedalhitting(combo: int) -> PedalHitting:
	assert(false) # Not implemented
	return null


func make_pedalmissing(last_combo: int) -> PedalMissing:
	assert(false) # Not implemented
	return null


func hit():
	is_hit = true
	queue_free()


func miss():
	queue_free()