extends Node

func get(name):
	var pack = load("res://sprite_packs/default/pack.tres")
	var palette = pack.head("palette_%s" % name)
	var image = palette.atlas.get_data()
	image.lock()
	var pos = palette.region.position
	var color = image.get_pixel(pos.x, pos.y)
	image.unlock()
	return color