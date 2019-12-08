extends Node2D

class_name GameDying
"""GameDying is a base class for the hero dying animation.

The subclasses are responsible for calling 'finish'
when it's finished.
"""

signal finished()


func init(hero: GameHero):
	position = hero.position


func finish():
	emit_signal("finished")
	queue_free()