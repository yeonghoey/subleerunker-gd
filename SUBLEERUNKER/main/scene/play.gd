extends "res://main/scene/scene.gd"

const Stadium := preload("res://game/stadium/stadium.gd")
const Stage := preload("res://game/stage/stage.gd")
const Preset := preload("res://game/preset/preset.gd")
const Indicator := preload("res://main/scene/play_indicator.gd")

const ModeSelection := preload("res://game/stage/modeselection.tscn")
const Leaderboard := preload("res://game/stage/leaderboard.tscn")
const InGame := preload("res://game/stage/ingame.tscn")
const ScoreUpload := preload("res://game/stage/scoreupload.tscn")

signal backed()

var _last_mode := ""

var _preset: Preset
var _myrecord_break := {}

onready var _Stadium: Stadium = find_node("Stadium")
onready var _Indicator: Indicator = find_node("Indicator")


func init(last_mode: String) -> void:
	_last_mode = last_mode


func _ready():
	_present_modeselection(_last_mode)


func _present_modeselection(last_mode: String):
	var modeselection := ModeSelection.instance()
	modeselection.init(last_mode)
	modeselection.connect("selected", self, "_on_modeselection_selected", [modeselection])
	modeselection.connect("canceled", self, "_on_modeselection_canceled")
	_Stadium.present(modeselection)


func _on_modeselection_selected(mode_name: String, modeselection: Stage):
	modeselection.close()
	_preset = _load_preset(mode_name)
	_present_leaderboard()


func _on_modeselection_canceled():
	emit_signal("backed")


func _present_leaderboard():
	var leaderboard := Leaderboard.instance()
	leaderboard.init(_preset, _myrecord_break)
	leaderboard.connect("started", self, "_on_leaderboard_started", [leaderboard])
	leaderboard.connect("canceled", self, "_on_leaderboard_canceled", [leaderboard])
	_Stadium.present(leaderboard)


func _on_leaderboard_started(score_old: int, leaderboard: Stage):
	leaderboard.close()
	_present_ingame(score_old)


func _on_leaderboard_canceled(leaderboard: Stage):
	leaderboard.close()
	_present_modeselection(_preset.take("name"))


func _present_ingame(score_old: int):
	var ingame := InGame.instance()
	ingame.init(_preset)
	ingame.connect("started", self, "_on_ingame_started")
	ingame.connect("scored", self, "_on_ingame_scored")
	ingame.connect("combo_hit", self, "_on_ingame_combo_hit")
	ingame.connect("combo_missed", self, "_on_ingame_combo_missed")
	ingame.connect("player_hit", self, "_on_ingame_player_hit", [score_old])
	ingame.connect("ended", self, "_on_ingame_ended", [ingame])
	ingame.connect("tree_exiting", self, "_on_ingame_tree_exiting")
	_Stadium.present(ingame)
	_Indicator.display({score=true, combo=true})


func _on_ingame_started(initial_score: int, initial_n_combo: int) -> void:
	_Indicator.display({score=true, combo=true})
	_Indicator.update_score(initial_score)
	_Indicator.update_combo(initial_n_combo)


func _on_ingame_scored(score: int) -> void:
	_Indicator.update_score(score)


func _on_ingame_combo_hit(n_combo: int) -> void:
	_Indicator.update_combo(n_combo)


func _on_ingame_combo_missed(n_combo: int, last_n_combo:int) -> void:
	# TODO: extend this to show some effects depending on last_n_combo
	_Indicator.update_combo(n_combo)


func _on_ingame_player_hit(score_new: int, score_old: int) -> void:
	if score_new > score_old:
		_overlay_scoreupload(score_new, score_old)
	else:
		_myrecord_break.clear()


func _on_ingame_ended(ingame: Stage) -> void:
	ingame.close()
	_Indicator.display({score=true, combo=false})


func _on_ingame_tree_exiting():
	# NOTE: Present leaderboard when ingame is about to be removed,
	# instead of receiving a custom signal.
	# This is because ingame can be closed in two ways, just "ended" or
	# "ended" and scoreupload is "done"(when score uploading 's required)
	_present_leaderboard()


func _overlay_scoreupload(score_new: int, score_old: int):
	var scoreupload := ScoreUpload.instance()
	scoreupload.init(_preset, score_new, score_old)
	scoreupload.connect("done", self, "_on_scoreupload_done", [scoreupload])
	_Stadium.overlay(scoreupload)


func _on_scoreupload_done(myrecord_break: Dictionary, scoreupload: Stage) -> void:
	scoreupload.close()
	_myrecord_break = myrecord_break


func _load_preset(mode_name: String) -> Preset:
	return load("res://game/preset/%s.gd" % mode_name).new()