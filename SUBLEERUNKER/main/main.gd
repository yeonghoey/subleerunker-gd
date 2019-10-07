extends Node 

const GameConstants = preload("res://game/constants.gd")

onready var viewport_size = get_viewport().size
onready var center_pos = Vector2((viewport_size.x - GameConstants.WIDTH)/2, 0)


func _ready():
	_add_steam()
	_add_background()
	_connect_signals()
	# TODO: Added this temporarily. Remove this
	Signals.emit_signal("domain_changed", "default")
	Signals.emit_signal("ended", 0)


func _add_steam():
	var steam_client = preload("res://steam/steam_client.gd").new()
	add_child(steam_client)


func _add_background():
	var bg = ColorRect.new()
	bg.rect_position = center_pos
	bg.rect_size = GameConstants.SIZE
	bg.color = _get_background_color()
	add_child(bg)


func _get_background_color() -> Color:
	var palette = preload("res://palette/default/palette.tscn").instance()
	return palette.pick("Background")


func _connect_signals():
	Signals.connect("started", self, "on_started")
	Signals.connect("ended", self, "on_ended")


func on_started():
	start_game()


func on_ended(last_score):
	# TODO: Handle Highscore Here
	show_menu()


func start_game() -> void:
	var game := preload("res://game/game.tscn").instance()
	game.position = center_pos
	add_child(game)


func show_menu() -> void:
	var menu := preload("res://menu/default/menu.tscn").instance()
	menu.position = center_pos
	add_child(menu)