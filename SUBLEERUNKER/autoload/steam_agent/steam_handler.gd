extends Node

enum LeaderboardDataRequest {
	Global = 0,
	GlobalAroundUser = 1,
	Friends = 2,
}


func _ready():
	Signals.connect("highscores_requested", self, "_on_highscores_requested")
	Signals.connect("score_upload_requested", self, "_on_score_upload_requested")


func _process(delta):
	Steam.run_callbacks()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Steam.shutdown()


func _on_highscores_requested(domain):
	# Find the leaderboard first because
	# the leaderboard handle managed by GodotSteam internally
	# will be used for the next request
	Steam.findLeaderboard(domain)
	var result = yield(Steam, "leaderboard_find_result")
	var found = result[1]
	assert found == 1
	
	Steam.downloadLeaderboardEntries(1, 10, LeaderboardDataRequest.Global)
	yield(Steam, "leaderboard_scores_downloaded")
	var entries = Steam.getLeaderboardEntries()
	for entry in entries:
		var name = Steam.getFriendPersonaName(entry["steamID"])
		entry["name"] = name
	Signals.emit_signal("highscores_responded", entries)


func _on_score_upload_requested(score):
	var keep_best = true
	Steam.uploadLeaderboardScore(score, keep_best)
	var ret = yield(Steam, "leaderboard_score_uploaded")
	var result = {
		success = (ret[0] != 0),
		score = ret[1],
		score_changed = (ret[2] != 0),
		global_rank_new = ret[3],
		global_rank_previous = ret[4]
	}
	Signals.emit_signal("score_upload_responded", result)