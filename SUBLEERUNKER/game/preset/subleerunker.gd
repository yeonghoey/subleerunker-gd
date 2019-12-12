extends "res://game/preset/preset.gd"


func _init().({
	name = "subleerunker",
	labelcolor = Color("#ffffff"),

	Background = preload("res://game/background/black.tscn"),
	Hero = preload("res://game/hero/sublee.tscn"),
	HeroDying = preload("res://game/herodying/burning.tscn"),
	Drop = preload("res://game/drop/flame.tscn"),
	DropLanding = preload("res://game/droplanding/dispersing.tscn"),
	DropSpawner = preload("res://game/dropspawner/framerand.tscn"),
	Pedal = preload("res://game/pedal/yellowbar.tscn"),
	PedalHitting = preload("res://game/pedalhitting/xnum.tscn"),
	PedalMissing = preload("res://game/pedalmissing/dummy.tscn"),
	PedalSpawner = preload("res://game/pedalspawner/oneatatime.tscn"),
}):
    pass