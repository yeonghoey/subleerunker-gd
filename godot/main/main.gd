extends Node 

func _ready():
	add_background()
	connect_signals()
	Signals.emit_signal("ended", 0)

func add_background():
	var v = get_viewport()
	var r = v.get_visible_rect()
	var bg = ColorRect.new()
	bg.rect_position = r.position
	bg.rect_size = r.size
	bg.color = PaletteDeprecated.get("background")
	add_child(bg)
	move_child(bg, 0)

func connect_signals():
	Signals.connect("started", self, "on_started")
	Signals.connect("ended", self, "on_ended")

func on_started():
	start_game()

func on_ended(last_score):
	# TODO: Handle Highscore Here
	show_menu()

func start_game() -> void:
	var game := preload("res://game/game.tscn").instance()
	add_child(game)

func show_menu() -> void:
	var menu := preload("res://menu/default/menu.tscn").instance()
	add_child(menu)