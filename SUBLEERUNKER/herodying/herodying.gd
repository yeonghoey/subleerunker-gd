extends Node2D
"""The base class of the hero dying animations.

The subclasses are responsible for freeing on their own
when it's finished.
"""

const HeroAlive := preload("res://heroalive/heroalive.gd")


func init(heroalive: HeroAlive):
	position = heroalive.position