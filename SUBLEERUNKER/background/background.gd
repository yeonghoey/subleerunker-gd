extends Node2D


func hero_starting_pos(hero_size: Vector2) -> Vector2:
	"""Place the hero at the bottom-center position by default
	"""
	var r := play_area()
	var x := r.position.x + (r.size.x / 2)
	var y := r.end.y - (hero_size.y /2)
	return Vector2(x, y)


func play_area() -> Rect2:
	return Rect2(0, 0, 320, 480)
