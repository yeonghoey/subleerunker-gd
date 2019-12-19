extends "res://game/stage/stage.gd"
"""This is reponsible for uploading score to Steam.

Because Steam rate limits score upload, uploading scores may fail.
This will explain this and let the player wait if the first try failed.
"""

const Preset := preload("res://game/preset/preset.gd")

signal done(myrecord_break)

var _preset: Preset
var _score_new := 0
var _score_old := 0
var _retry_count := -1

onready var _Timer: Timer = find_node("Timer")
onready var _Body: MarginContainer = find_node("Body")
onready var _Retry = find_node("Retry")
onready var _Seconds = find_node("Seconds")


func init(preset: Preset, score_new: int, score_old: int):
	_preset = preset
	_score_new = score_new
	_score_old = score_old


func _ready():
	assert(_preset != null)
	_Body.visible = false
	_override_labelcolor()
	_try_upload_score()


func _override_labelcolor() -> void:
	var labelcolor: Color = _preset.take("labelcolor")
	get_tree().call_group("GameLabel",
			"add_color_override", "font_color", labelcolor)


func _try_upload_score() -> void:
	var leaderboardname = _preset.take("leaderboardname")
	SteamAgent.upload_score(leaderboardname, _score_new, self, "_on_upload_score")


func _on_upload_score(result) -> void:
	if result.get("success"):
		var myrecord_break := _compile_myrecord_break(result)
		emit_signal("done", myrecord_break)
		close()
		return

	if _retry_count == -1:
		_Body.visible = true
		_Timer.connect("timeout", self, "_try_upload_score")
		_Timer.start()
	_retry_count += 1
	_update_retry()


func _compile_myrecord_break(result: Dictionary) -> Dictionary:
	var fields_exist := result.has_all(
			["success", "score_changed", "global_rank_previous", "global_rank_new"])
	if fields_exist and result["success"] and result["score_changed"]:
		return {
			rank_new = result["global_rank_new"],
			rank_old = result["global_rank_previous"],
			score_new = _score_new,
			score_old = _score_old,
		}
	else:
		return {}


func _update_retry():
	_Retry.text = "%d/10" % _retry_count


func _process(delta: float):
	_update_seconds()


func _update_seconds():
	var s = int(_Timer.time_left)
	_Seconds.text = "Next retry in %d seconds" % s