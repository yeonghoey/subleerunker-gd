extends Node

const Modebox := preload("res://modebox/modebox.gd")
const Statbox := preload("res://statbox/statbox.gd")
const Options := preload("res://options/options.gd")

const MODES := ["sublee", "sunmee", "yeongho"]

onready var _scenes = {
	"intro": preload("res://scene/intro/intro.tscn").instance(),
	"title": preload("res://scene/title/title.tscn").instance(),
	"play": preload("res://scene/play/play.tscn").instance(),
	"achievements_view": preload("res://scene/achievements_view/achievements_view.tscn").instance(),
	"options_control": preload("res://scene/options_control/options_control.tscn").instance(),
}

onready var _modebox := Modebox.new(MODES)
onready var _statbox := Statbox.new()
onready var _options := Options.new()


func _ready():
	_init_intro()
	_init_title()
	_init_play()
	_init_achievements_view()
	_init_options_control()
	_show_intro()


func _init_intro() -> void:
	_scenes["intro"].connect("finished", self, "_transit", ["intro", "title"])


func _init_title() -> void:
	_scenes["title"].connect("play_selected", self, "_transit", ["title", "play"])
	_scenes["title"].connect("achievements_view_selected", self, "_transit", ["title", "achievements_view"])
	_scenes["title"].connect("options_control_selected", self, "_transit", ["title", "options_control"])


func _init_play() -> void:
	_scenes["play"].init(_modebox, _statbox)
	_scenes["play"].connect("backed", self, "_transit", ["play", "title"])


func _init_achievements_view() -> void:
	_scenes["achievements_view"].connect("backed", self, "_transit", ["achievements_view", "title"])


func _init_options_control() -> void:
	_scenes["options_control"].init(_options)
	_scenes["options_control"].connect("backed", self, "_transit", ["options_control", "title"])


func _show_intro() -> void:
	add_child(_scenes["intro"])


func _transit(from: String, to: String):
	# There can be a timing issue when directly
	# adding/removing scenes here
	call_deferred("_change_scene", _scenes[from], _scenes[to])


func _change_scene(from: Node, to: Node) -> void:
	remove_child(from)
	add_child(to)