extends Node

const HeroAlive := preload("res://heroalive/heroalive.gd")
const HeroDying := preload("res://herodying/herodying.gd")

export(PackedScene) var HeroAlive_: PackedScene
export(PackedScene) var HeroDying_: PackedScene
export(Vector2) var size: Vector2

signal hit()


func init(starting_pos: Vector2) -> void:
	"""Place the hero in the bottom center of the boundary.

	This can be overriden if necessary.
	Returns self so that this can be method-chained.
	"""
	var heroalive: HeroAlive = HeroAlive_.instance()
	heroalive.position = starting_pos
	heroalive.connect("tree_exiting", self, "_on_heroalive_tree_exiting", [heroalive])
	add_child(heroalive)


func _on_heroalive_tree_exiting(heroalive: HeroAlive):
	var herodying_packed := interpret_dyingmessage(heroalive.dyingmessage())
	var herodying: HeroDying = herodying_packed.instance()
	herodying.init(heroalive)
	herodying.connect("tree_exiting", self, "queue_free")
	add_child(herodying)
	emit_signal("hit")


func interpret_dyingmessage(dyingmessage: String) -> PackedScene:
	"""Return a PackedScene of HeroDying using dyingmessage.

	Subclasses can override this to customize selecting HeroDying.
	"""
	return HeroDying_