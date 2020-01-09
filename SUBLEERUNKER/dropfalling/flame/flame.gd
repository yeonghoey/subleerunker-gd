extends "res://dropfalling/dropfalling.gd"


func init(boundary: Vector2, hero: Hero) -> void:
	"""Place the drop in the top random of the boundary.
	"""
	var x = (boundary.x - width*2) * randf() + width
	position = Vector2(x, -height)


func _on_Area2D_area_entered(area):
	queue_free()