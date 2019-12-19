extends Control

const Stadium := preload("res://game/stadium/stadium.gd")
const Preset := preload("res://game/preset/preset.gd")

const ModeSelection := preload("res://game/stage/modeselection.tscn")
const Leaderboard := preload("res://game/stage/leaderboard.tscn")
const InGame := preload("res://game/stage/ingame.tscn")
const ScoreUpload := preload("res://game/stage/scoreupload.tscn")


var _current_mode := ""
var _preset: Preset
var _myrecord_break := {}
var _score_old := 0

onready var _Stadium: Stadium = find_node("Stadium")


func _ready():
	_present_modeselection()


func _present_modeselection():
	var modeselection := ModeSelection.instance()
	modeselection.connect("selected", self, "_on_modeselection_selected")
	modeselection.connect("canceled", self, "_on_modeselection_canceled")
	_Stadium.present(modeselection)


func _on_modeselection_selected(mode_name: String):
	_preset = _load_preset(mode_name)
	_present_leaderboard()


func _on_modeselection_canceled():
	pass


func _present_leaderboard():
	var leaderboard := Leaderboard.instance()
	leaderboard.init(_preset, _myrecord_break)
	leaderboard.connect("started", self, "_on_leaderboard_started")
	leaderboard.connect("canceled", self, "_on_leaderboard_canceled")
	_Stadium.present(leaderboard)



func _on_leaderboard_started(score_old: int):
	_score_old = score_old
	_present_ingame()


func _on_leaderboard_canceled():
	pass


func _present_ingame():
	var ingame := InGame.instance()
	ingame.init(_preset)
	# TODO: Connect signals!
	_Stadium.present(ingame)


func _load_preset(mode_name: String) -> Preset:
	return load("res://game/preset/%s.gd" % mode_name).new()