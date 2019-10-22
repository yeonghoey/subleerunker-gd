extends Control
"""Retries score upload.

Because Steam rate limits score upload, uploading scores may fail.
This will only be added to the scene when the first try failed.

This shows the reason why it failed and the current status retries.
This assumes that its parent is the Ingame Session.
"""

onready var _timer: Timer = $Timer
onready var _retry = find_node("Retry")
onready var _seconds = find_node("Seconds")

var _retry_count := 0
var _end_score := 0


func init(end_score: int):
	_end_score = end_score


func _ready():
	_timer.connect("timeout", self, "_on_timeout")


func _process(delta: float):
	_update_seconds()


func _on_timeout():
	SteamAgent.upload_score("default", _end_score, self, "_on_upload_score")


func _on_upload_score(result):
	if result["success"]:
		Signals.emit_signal("retry_score_upload_succeeded", result)
		_timer.stop()
		queue_free()
	else:
		_retry_count += 1
		_update_retry()


func _update_seconds():
	var s = int(_timer.time_left)
	_seconds.text = "Next retry in %d seconds" % s


func _update_retry():
	_retry.text = "%d/10" % _retry_count