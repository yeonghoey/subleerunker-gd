extends Node
"""Subclasses of this should call cue() when they decided to place a Pedal.

The signal argument 'pedals' should be array, each element of which
is a new Pedal instance.
"""

const Pedal := preload("res://pedal/pedal.gd")

signal cued(pedals)


func cue(pedals: Array) -> void:
	emit_signal("cued", pedals)


func on_pedal_initialized(pedal: Pedal) -> void:
	"""on_pedal_initialized will be called with a newly spawned Pedal.
	"""
	pass