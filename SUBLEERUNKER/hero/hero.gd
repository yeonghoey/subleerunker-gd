extends Node


const HeroAlive := preload("res://heroalive/heroalive.gd")
const HeroDying := preload("res://herodying/herodying.gd")

export(PackedScene) var HeroAlive_: PackedScene
export(PackedScene) var HeroDying_: PackedScene

signal hit()


func init(boundary: Vector2) -> void:
	"""Place the hero in the bottom center of the boundary.

	This can be overriden if necessary.
	Returns self so that this can be method-chained.
	"""
	var heroalive: HeroAlive = HeroAlive_.instance()
	heroalive.init(boundary)
	heroalive.connect("tree_exiting", self, "_on_heroalive_tree_exiting", [heroalive])
	add_child(heroalive)


func _on_heroalive_tree_exiting(heroalive: HeroAlive):
	var herodying: HeroDying = HeroDying_.instance()
	herodying.init(heroalive)
	herodying.connect("tree_exiting", self, "queue_free")
	add_child(herodying)
	emit_signal("hit")