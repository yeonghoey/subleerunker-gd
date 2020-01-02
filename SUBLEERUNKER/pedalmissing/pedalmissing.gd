extends Node2D
"""The base class of the pedal missing animations.

The subclasses are responsible for calling 'finish'
when it's finished.
"""

const Pedal := preload("res://pedal/pedal.gd")

var _last_n_combo: int = 0


func init(pedal: Pedal, last_n_combo: int):
	position = pedal.position
	_last_n_combo = last_n_combo


func last_n_combo() -> int:
	return _last_n_combo


func finish():
	queue_free()