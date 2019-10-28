extends Node

onready var _scenes = {
	"intro": preload("res://scenes/intro/intro.tscn").instance(),
	"title": preload("res://scenes/title/title.tscn").instance(),
	"play": preload("res://scenes/play/play.tscn").instance(),
	"vs": preload("res://scenes/vs/vs.tscn").instance(),
	"achievements": preload("res://scenes/achievements/achievements.tscn").instance(),
	"options": preload("res://scenes/options/options.tscn").instance(),
}


func _ready():
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_connect_signals()
	add_child(_scenes["intro"])


func _connect_signals():
	Signals.connect("scene_intro_ended", self, "_transit", ["intro", "title"])
	Signals.connect("scene_play_selected", self, "_transit", ["title", "play"])
	Signals.connect("scene_vs_selected", self, "_transit", ["title", "vs"])
	Signals.connect("scene_achievements_selected", self, "_transit", ["title", "achievements"])
	Signals.connect("scene_options_selected", self, "_transit", ["title", "options"])
	Signals.connect("scene_play_closed", self, "_transit", ["play", "title"])
	Signals.connect("scene_vs_closed", self, "_transit", ["vs", "title"])
	Signals.connect("scene_achievements_closed", self, "_transit", ["achievements", "title"])
	Signals.connect("scene_options_closed", self, "_transit", ["options", "title"])


func _transit(from: String, to: String):
	remove_child(_scenes[from])
	add_child(_scenes[to])