extends Node
"""Subclasses of this should call cue()' when they decided to spawn a Drop.

The signal argument 'drops' should be array, each element of which
is a new Drop instance.
"""

const Drop := preload("res://drop/drop.gd")

signal cued(drops)


func cue(drops: Array) -> void:
	emit_signal("cued", drops)


func on_drop_initialized(drop: Drop) -> void:
	pass