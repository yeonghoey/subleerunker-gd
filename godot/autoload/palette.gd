extends Node

func get(name):
	var path = "res://autoload/palette-%s.tres" % name
	var palette = load(path)
	var image = palette.atlas.get_data()
	image.lock()
	var pos = palette.region.position
	var color = image.get_pixel(pos.x, pos.y)
	image.unlock()
	return color