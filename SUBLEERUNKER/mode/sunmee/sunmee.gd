extends "res://mode/mode.gd"


func _init().({
	name = "sunmee",
	icon_on = preload("sunmee_on.png"),
	icon_off = preload("sunmee_off.png"),
	labelcolor = Color("#ffffff"),
	Background = preload("res://background/black/black.tscn"),
	Hero = preload("res://hero/sunmee/sunmee.tscn"),
	HeroDying = preload("res://herodying/burning/burning.tscn"),
	Drop = preload("res://drop/flame/flame.tscn"),
	DropLanding = preload("res://droplanding/dispersing/dispersing.tscn"),
	DropSpawner = preload("res://dropspawner/framerand/framerand.tscn"),
	Pedal = preload("res://pedal/yellowbar/yellowbar.tscn"),
	PedalHitting = preload("res://pedalhitting/xnum/xnum.tscn"),
	PedalMissing = preload("res://pedalmissing/dummy/dummy.tscn"),
	PedalSpawner = preload("res://pedalspawner/oneatatime/oneatatime.tscn"),
	BGM = preload("res://bgm/dddd/dddd.tscn"),
}):
    pass