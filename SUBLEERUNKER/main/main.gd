extends Node

onready var _scenes = {
	"intro": preload("res://main/scene/intro.tscn").instance(),
	"title": preload("res://main/scene/title.tscn").instance(),
	"play": preload("res://main/scene/play.tscn").instance(),
	"achievements": preload("res://main/scene/achievements.tscn").instance(),
	"options": preload("res://main/scene/options.tscn").instance(),
}


func _ready():
	_init_intro()
	_init_title()
	_init_play()
	_init_achievements()
	_init_options()
	_show_intro()


func _init_intro() -> void:
	_scenes["intro"].connect("finished", self, "_transit", ["intro", "title"])


func _init_title() -> void:
	_scenes["title"].connect("play_selected", self, "_transit", ["title", "play"])
	_scenes["title"].connect("achievements_selected", self, "_transit", ["title", "achievements"])
	_scenes["title"].connect("options_selected", self, "_transit", ["title", "options"])


func _init_play() -> void:
	# TODO: Load the last selected mode
	_scenes["play"].init("subleerunker")
	_scenes["play"].connect("backed", self, "_transit", ["play", "title"])


func _init_achievements() -> void:
	_scenes["achievements"].connect("backed", self, "_transit", ["achievements", "title"])


func _init_options() -> void:
	_scenes["options"].init()
	_scenes["options"].connect("backed", self, "_transit", ["options", "title"])


func _show_intro() -> void:
	add_child(_scenes["intro"])


func _transit(from: String, to: String):
	# There can be a timing issue when directly
	# adding/removing scenes here
	call_deferred("_change_scene", _scenes[from], _scenes[to])


func _change_scene(from: Node, to: Node) -> void:
	remove_child(from)
	add_child(to)