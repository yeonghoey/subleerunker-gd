extends "res://game/stage/stage.gd"

const Preset := preload("res://game/preset/preset.gd")

signal started(score_old)
signal canceled()

var _preset: Preset
var _myrecord_break: Dictionary

var _myrecord := {rank=0, score=0}
var _myrecord_fetched := false

onready var _HighScores = find_node("HighScores")
onready var _MyRecord = find_node("MyRecord")
onready var _PressKey = find_node("PressKey")


func init(preset: Preset, myrecord_break: Dictionary) -> void:
	assert _myrecord_break.empty() or _myrecord_break.has_all(
			["rank_new", "rank_old", "score_new", "score_old"])
	_preset = preset
	_myrecord_break = myrecord_break


func _ready():
	_prepend_background()
	_override_labelcolor()
	_PressKey.visible = false
	var leaderboardname: String = _preset.take("leaderboardname")
	SteamAgent.fetch_myrecord(leaderboardname, self, "_on_fetch_myrecord")
	SteamAgent.fetch_highscores(leaderboardname, self, "_on_fetch_highscores")


func _prepend_background():
	var background := _preset.make("Background")
	add_child(background)
	move_child(background, 0)

	
func _override_labelcolor():
	var labelcolor: Color = _preset.take("labelcolor")
	get_tree().call_group("GameLabel",
			"add_color_override", "font_color", labelcolor)


func _on_fetch_myrecord(entries):
	if entries != null and entries.size() == 1:
		var entry = entries[0]
		_myrecord["rank"] = entry["global_rank"]
		_myrecord["score"] = entry["score"]
	_MyRecord.populate(_myrecord, _myrecord_break)
	_myrecord_fetched = true
	_PressKey.visible = true


func _on_fetch_highscores(entries):
	# Translate Steam callResult(entries) into records,
	# an Array of Dictionaries, each of which contains
	# "name", "steam_id", "rank", "score"
	var records := []
	for entry in entries:
		records.append({
			name = entry["name"],
			steam_id = entry["steamID"],
			rank = entry["global_rank"],
			score = entry["score"],
		})
	_HighScores.populate(records)


func _input(event):
	var start := (
		Input.is_action_pressed("ui_left") or 
		Input.is_action_pressed("ui_right") or
		Input.is_action_pressed("ui_accept"))
	if start and _myrecord_fetched:
		emit_signal("started", _myrecord["score"])
		return
		
	var cancel := (
		Input.is_action_pressed("ui_cancel"))
	if cancel:
		emit_signal("canceled")
		return