extends Node
"""Subclasses of this should call cue()' when they decided to spawn a Drop.

The signal argument 'hints' should be array, the length of which represents
the number of drops decided to spawn, and each element will be passed to Drop.init()
"""

const Drop := preload("res://dropfalling/dropfalling.gd")

signal cued(hints)


func cue(hints: Array) -> void:
	emit_signal("cued", hints)


func on_drop_spawned(drop: Drop) -> void:
	pass