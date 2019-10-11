extends Node


func _ready():
	show_intro()


func show_intro():
	var intro = preload("res://intro/intro.tscn").instance()
	intro.connect("ended", self, "_on_intro_ended")
	add_child(intro)


func _on_intro_ended():
	show_title()


func show_title():
	var title = preload("res://title/title.tscn").instance()
	add_child(title)