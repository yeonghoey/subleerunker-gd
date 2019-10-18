extends Node


enum LeaderboardDataRequest {
	Global = 0,
	GlobalAroundUser = 1,
	Friends = 2,
}


func find_leaderboard(name: String):
	Steam.connect(
		"leaderboard_find_result", 
		self, "_leaderboard_find_result", 
		[], CONNECT_ONESHOT)
	Steam.findLeaderboard(name)


func _leaderboard_find_result(handle, found):
	# handle is managed by GodotSteam internally
	assert found == 1

#
#func _ended(last_score):
#	# Retrieves only the top player
#	Steam.downloadLeaderboardEntries(1, 1, LeaderboardDataRequest.Global)
#	Steam.uploadLeaderboardScore(last_score, true)


func _leaderboard_scores_downloaded():
	var entries = Steam.getLeaderboardEntries()
	for entry in entries:
		var name = Steam.getFriendPersonaName(entry["steamID"])
		entry["name"] = name
	Signals.emit_signal("top10_scores_downloaded", entries)


func _leaderboard_score_uploaded(success, score, score_changed, global_rank_new, global_rank_previous):
	# TODO: Animate the rank transition with information here
	pass