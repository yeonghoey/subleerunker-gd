extends Node

func _ready():
	add_background()

func add_background():
	var v = get_viewport()
	var r = v.get_visible_rect()
	var bg = ColorRect.new()
	bg.rect_position = r.position
	bg.rect_size = r.size
	bg.color = get_color("res://main/palette-background.tres")
	add_child(bg)

func get_color(res):
	var palette = load(res)
	var image = palette.atlas.get_data()
	image.lock()
	var pos = palette.region.position
	var color = image.get_pixel(pos.x, pos.y)
	image.unlock()
	return color

func _process(delta):
	pass

func _physics_process(delta):
	pass