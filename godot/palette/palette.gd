extends Node2D

func pick(name: String) -> Color:
	var palette = get_node(name).texture
	var image = palette.atlas.get_data()
	image.lock()
	var pos = palette.region.position
	var color = image.get_pixel(pos.x, pos.y)
	image.unlock()
	print('hi')
	return color