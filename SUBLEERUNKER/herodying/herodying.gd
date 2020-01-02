extends Node2D
"""The base class of the hero dying animations.

The subclasses are responsible for calling 'finish'
when it's finished.
"""

const Hero := preload("res://hero/hero.gd")


func init(hero: Hero):
	position = hero.position


func finish():
	queue_free()