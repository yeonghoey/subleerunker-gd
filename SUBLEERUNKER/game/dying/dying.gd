extends Node2D
"""The base class of the hero dying animations.

The subclasses are responsible for calling 'finish'
when it's finished.
"""

const Hero := preload("res://game/hero/hero.gd")

signal finished()


func init(hero: Hero):
	position = hero.position


func finish():
	emit_signal("finished")
	queue_free()