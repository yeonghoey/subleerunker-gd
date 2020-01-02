extends "res://game/preset/preset.gd"


func _init().({
	name = "subleerunker",
	displayname = "subleerunker",
	labelcolor = Color("#796755"),
	Background = preload("res://game/background/mountain/mountain.tscn"),
	Hero = preload("res://game/hero/yeongho/yeongho.tscn"),
	HeroDying = preload("res://game/herodying/burning/burning.tscn"),
	Drop = preload("res://game/drop/flame/flame.tscn"),
	DropLanding = preload("res://game/droplanding/dispersing/dispersing.tscn"),
	DropSpawner = preload("res://game/dropspawner/framerand/framerand.tscn"),
	Pedal = preload("res://game/pedal/yellowbar/yellowbar.tscn"),
	PedalHitting = preload("res://game/pedalhitting/xnum/xnum.tscn"),
	PedalMissing = preload("res://game/pedalmissing/dummy/dummy.tscn"),
	PedalSpawner = preload("res://game/pedalspawner/oneatatime/oneatatime.tscn"),
	BGM = preload("res://game/bgm/dddd/dddd.tscn"),
}):
    pass