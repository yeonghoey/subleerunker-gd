extends Node
"""Subclasses of this should call cue() when they decided to place a Pedal.

The signal argument 'hints' should be array, the length of which represents
the number of pedals decided to spawn, and each element will be passed to Pedal.init()
"""

const Pedal := preload("res://game/pedal/pedal.gd")

signal cued(hints)


func cue(hints: Array) -> void:
	emit_signal("cued", hints)


func on_pedal_spawned(pedal: Pedal) -> void:
	"""on_pedal_spawned will be called with a newly spawned Pedal.

	This can be used for signaling
	"""
	pass