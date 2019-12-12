extends "res://game/preset/preset.gd"


func _init().({
	name = "subleerunker",
	labelcolor = Color("#ffffff"),

	Background = preload("res://game/background/black.tscn"),
	Hero = preload("res://game/hero/sublee.tscn"),
	Drop = preload("res://game/drop/flame.tscn"),
	Pedal = preload("res://game/pedal/yellowbar.tscn"),
	Landing = preload("res://game/landing/dispersing.tscn"),
	Dying = preload("res://game/dying/burning.tscn"),
}):
    pass