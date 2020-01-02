extends Node2D
"""The base class of the pedal hitting animations.

The subclasses are responsible for calling 'finish'
when it's finished.
"""

const Pedal := preload("res://pedal/pedal.gd")

var _n_combo: int = 0


func init(pedal: Pedal, n_combo: int):
	position = pedal.position
	_n_combo = n_combo


func n_combo() -> int:
	return _n_combo


func finish():
	queue_free()