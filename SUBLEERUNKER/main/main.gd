extends Node


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	show_intro()


func show_intro():
	var intro = preload("res://scenes/intro/intro.tscn").instance()
	intro.connect("ended", self, "on_intro_ended")
	add_child(intro)


func on_intro_ended():
	show_title()


func show_title():
	var title = preload("res://scenes/title/title.tscn").instance()
	title.connect("play", self, "on_title_play")
	title.connect("vs", self, "on_title_vs")
	title.connect("achievements", self, "on_title_achievements")
	title.connect("options", self, "on_title_options")
	add_child(title)


func on_title_play():
	var play = preload("res://scenes/play/play.tscn").instance()
	add_child(play)


func on_title_vs():
	var vs = preload("res://scenes/vs/vs.tscn").instance()
	add_child(vs)


func on_title_achievements():
	var achievements = preload("res://scenes/achievements/achievements.tscn").instance()
	add_child(achievements)


func on_title_options():
	var options = preload("res://scenes/options/options.tscn").instance()
	add_child(options)