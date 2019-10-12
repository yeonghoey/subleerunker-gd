extends Node


onready var intro = preload("res://scenes/intro/intro.tscn").instance()
onready var title = preload("res://scenes/title/title.tscn").instance()
onready var play = preload("res://scenes/play/play.tscn").instance()
onready var vs = preload("res://scenes/vs/vs.tscn").instance()
onready var achievements = preload("res://scenes/achievements/achievements.tscn").instance()
onready var options = preload("res://scenes/options/options.tscn").instance()


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	connect_signals()
	add_child(intro)


func connect_signals():
	intro.connect("ended", self, "on_intro_ended")
	title.connect("play_selected", self, "on_title_play_selected")
	title.connect("vs_selected", self, "on_title_vs_selected")
	title.connect("achievements_selected", self, "on_title_achievements_selected")
	title.connect("options_selected", self, "on_title_options_selected")
	
	play.connect("closed", self, "on_play_closed")
	vs.connect("closed", self, "on_vs_closed")
	achievements.connect("closed", self, "on_achievements_closed")
	options.connect("closed", self, "on_options_closed")


func on_intro_ended():
	remove_child(intro)
	add_child(title)


func on_title_play_selected():
	remove_child(title)
	add_child(play)


func on_title_vs_selected():
	remove_child(title)
	add_child(vs)


func on_title_achievements_selected():
	remove_child(title)
	add_child(achievements)


func on_title_options_selected():
	remove_child(title)
	add_child(options)


func on_play_closed():
	remove_child(play)
	add_child(title)


func on_vs_closed():
	remove_child(vs)
	add_child(title)


func on_achievements_closed():
	remove_child(achievements)
	add_child(title)


func on_options_closed():
	remove_child(options)
	add_child(title)