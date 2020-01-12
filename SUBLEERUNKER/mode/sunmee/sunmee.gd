extends "res://mode/mode.gd"


func _init().({
	name = "sunmee",
	icon_on = preload("icon_on.png"),
	icon_off = preload("icon_off.png"),
	labelcolor = Color("#ffffff"),
	Background = preload("res://background/black/black.tscn"),
	Hero = preload("res://hero/sunmee/sunmee.tscn"),
	DropSpawner = preload("res://dropspawner/randframe/shower.tscn"),
	Pedal = preload("res://pedal/yellowbar/yellowbar.tscn"),
	PedalSpawner = preload("res://pedalspawner/oneatatime/oneatatime.tscn"),
	BGM = preload("res://bgm/dddd/dddd.tscn"),
	Cam = preload("res://cam/randshake/randshake.tscn"),
}):
    pass