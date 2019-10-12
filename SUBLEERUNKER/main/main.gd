extends Node


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	show_intro()


func show_intro():
	var intro = preload("res://intro/intro.tscn").instance()
	intro.connect("ended", self, "on_intro_ended")
	add_child(intro)


func on_intro_ended():
	show_title()


func show_title():
	var title = preload("res://title/title.tscn").instance()
	title.connect("play", self, "on_title_play")
	title.connect("vs", self, "on_title_vs")
	title.connect("achievements", self, "on_title_achievements")
	title.connect("options", self, "on_title_options")
	add_child(title)


func on_title_play():
	print('play')


func on_title_vs():
	print('vs')


func on_title_achievements():
	print('achievements')


func on_title_options():
	print('options')