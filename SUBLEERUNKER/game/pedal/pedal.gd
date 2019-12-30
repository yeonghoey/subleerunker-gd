extends Area2D
"""The base class of pedals, which are for the combo system.

Subclasses should call two methods when:
	- trigger, when the hero triggered this
	- disappear, when running out of duration.
"""

const Hero := preload("res://game/hero/hero.gd")

export(float) var width
export(float) var height

signal triggered()
signal disappeared()

var _signaled := false


func init(boundary: Vector2, hero: Hero, hint = null) -> void:
	"""Place the pedal in the bottom random of the boundary.

	This can be overriden if necessary.
	"""
	var x = (boundary.x - width*2) * randf() + width
	position = Vector2(x, boundary.y - height)


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