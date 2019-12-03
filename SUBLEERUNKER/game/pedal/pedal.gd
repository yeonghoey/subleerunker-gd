extends Area2D

class_name Pedal
"""Pedal is a base class for pedals, which is for combo system.



Subclasses should call two methods when:
	- trigger, when the hero triggered this
	- disappear, when running out of duration.
"""

export(float) var width
export(float) var height

signal triggered()
signal disappeared()

var _signaled := false


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