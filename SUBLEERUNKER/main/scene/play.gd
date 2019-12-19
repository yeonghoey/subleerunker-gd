extends Control

const Stadium := preload("res://game/stadium/stadium.gd")
const Preset := preload("res://game/preset/preset.gd")

const ModeSelection := preload("res://game/stage/modeselection.tscn")
const Leaderboard := preload("res://game/stage/leaderboard.tscn")
const InGame := preload("res://game/stage/ingame.tscn")
const ScoreUpload := preload("res://game/stage/scoreupload.tscn")


var _preset: Preset
var _myrecord_break := {}

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
	_present_ingame(score_old)


func _on_leaderboard_canceled():
	pass


func _present_ingame(score_old: int):
	var ingame := InGame.instance()
	ingame.init(_preset)
	ingame.connect("player_hit", self, "_on_ingame_player_hit", [score_old])
	ingame.connect("tree_exiting", self, "_on_ingame_tree_exiting")
	_Stadium.present(ingame)


func _on_ingame_player_hit(score_new: int, score_old: int):
	if score_new > score_old:
		_overlay_scoreupload(score_new, score_old)
	else:
		_myrecord_break.clear()


func _on_ingame_tree_exiting():
	# NOTE: Present leaderboard when ingame is about to be removed,
	# instead of receiving a custom signal.
	# This is because ingame can be closed in two ways, just "ended" or
	# "ended" and scoreupload is "done"(when score uploading 's required)
	_present_leaderboard()


func _overlay_scoreupload(score_new: int, score_old: int):
	var scoreupload := ScoreUpload.instance()
	scoreupload.init(_preset, score_new, score_old)
	scoreupload.connect("done", self, "_on_scoreupload_done")
	_Stadium.overlay(scoreupload)


func _on_scoreupload_done(myrecord_break: Dictionary) -> void:
	_myrecord_break = myrecord_break


func _load_preset(mode_name: String) -> Preset:
	return load("res://game/preset/%s.gd" % mode_name).new()