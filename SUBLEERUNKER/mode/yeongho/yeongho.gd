extends "res://mode/mode.gd"


func _init().({
	name = "yeongho",
	icon_on = preload("icon_on.png"),
	icon_off = preload("icon_off.png"),
	labelcolor = Color("#796755"),
	Background = preload("res://background/mountain/mountain.tscn"),
	Hero = preload("res://hero/yeongho/yeongho.tscn"),
	DropSpawner = preload("res://dropspawner/randframe/flame.tscn"),
	Pedal = preload("res://pedal/yellowbar/yellowbar.tscn"),
	PedalSpawner = preload("res://pedalspawner/oneatatime/oneatatime.tscn"),
	BGM = preload("res://bgm/dddd/dddd.tscn"),
	Cam = preload("res://cam/randshake/randshake.tscn"),
}):
    pass