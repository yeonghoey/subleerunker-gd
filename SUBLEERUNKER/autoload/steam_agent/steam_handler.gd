extends Node

enum LeaderboardDataRequest {
	Global = 0,
	GlobalAroundUser = 1,
	Friends = 2,
}

var current_domain := ""


func _ready():
	Signals.connect("myrank_requested", self, "_on_myrank_requested")
	Signals.connect("highscores_requested", self, "_on_highscores_requested")
	Signals.connect("score_upload_requested", self, "_on_score_upload_requested")


func _process(delta):
	Steam.run_callbacks()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Steam.shutdown()


func _on_myrank_requested(domain):
	if current_domain != domain:
		yield(_select_leaderboard(domain), "completed")
	var y = _download_leaderboard_entries(0, 0, LeaderboardDataRequest.GlobalAroundUser)
	var entries = yield(y, "completed")
	Signals.emit_signal("myrank_responded", entries)


func _on_highscores_requested(domain):
	if current_domain != domain:
		yield(_select_leaderboard(domain), "completed")
	var y = _download_leaderboard_entries(1, 10, LeaderboardDataRequest.Global)
	var entries = yield(y, "completed")
	Signals.emit_signal("highscores_responded", entries)


func _on_score_upload_requested(domain, score):
	if current_domain != domain:
		yield(_select_leaderboard(domain), "completed")
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


func _select_leaderboard(domain):
	# The leaderboard handle managed by GodotSteam internally
	# will be used for the next request
	Steam.findLeaderboard(domain)
	var result = yield(Steam, "leaderboard_find_result")
	var found = result[1]
	assert found == 1
	current_domain = domain


func _download_leaderboard_entries(start: int, end: int, type: int) -> Array:
	Steam.downloadLeaderboardEntries(start, end, type)
	yield(Steam, "leaderboard_scores_downloaded")
	var entries = Steam.getLeaderboardEntries()
	for entry in entries:
		var name = Steam.getFriendPersonaName(entry["steamID"])
		entry["name"] = name
	return entries