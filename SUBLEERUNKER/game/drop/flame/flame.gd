extends "res://game/drop/drop.gd"


func init(boundary: Vector2, hero: Hero, hint = null) -> void:
	"""Place the drop in the top random of the boundary.
	"""
	var x = (boundary.x - width*2) * randf() + width
	position = Vector2(x, -height)