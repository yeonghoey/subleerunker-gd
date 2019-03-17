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
	show_menu()

func get_color(res):
	var palette = load(res)
	var image = palette.atlas.get_data()
	image.lock()
	var pos = palette.region.position
	var color = image.get_pixel(pos.x, pos.y)
	image.unlock()
	return color

func show_menu() -> void:
	var menu := preload("res://menu/menu.tscn").instance()
	menu.connect("pressed", self, "start_game")
	add_child(menu)

func start_game() -> void:
	var game := preload("res://game/game.tscn").instance()
	game.connect("ended", self, "show_menu")
	add_child(game)