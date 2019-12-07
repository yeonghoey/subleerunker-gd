extends Area2D

class_name Pedal
"""Pedal is the base class for pedals, which are for the combo system.

Subclasses should call two methods when:
	- trigger, when the hero triggered this
	- disappear, when running out of duration.
"""

export(float) var width
export(float) var height

signal triggered()
signal disappeared()

var _signaled := false


func within(boundary: Vector2) -> Pedal:
	"""Place the pedal in the bottom random of the boundary.
	
	This can be overriden if necessary.
	Returns self so that this can be method-chained.
	"""
	var x = (boundary.x - width*2) * randf() + width
	position = Vector2(x, boundary.y - height)
	return self


func trigger():
	_signal("triggered")
	queue_free()


func disappear():
	_signal("disappeared")
	queue_free()


func _signal(name: String):
	if _signaled:
		return
	emit_signal(name)
	_signaled = true