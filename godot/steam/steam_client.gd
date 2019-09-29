extends Node


var initialized := false
var leaderboard = null


enum LeaderboardDataRequest {
	Global = 0,
	GlobalAroundUser = 1,
	Friends = 2,
}


func _ready():
	_try_init()
	_connect_signals()


func _try_init():
	var ret = Steam.steamInit()
	if ret["status"] == 0:
		initialized = true
	else:
		push_warning('Steam.steamInit() failed: %s' % ret)


func _connect_signals():
	Steam.connect("leaderboard_find_result", self, "_leaderboard_find_result")
	Steam.connect("leaderboard_scores_downloaded", self, "_leaderboard_scores_downloaded")
	Steam.connect("leaderboard_score_uploaded", self, "_leaderboard_score_uploaded")
	Signals.connect("domain_changed", self, "_domain_changed")
	Signals.connect("ended", self, "_ended")


func _process(delta):
	# TODO: Implement retry
	if initialized:
		Steam.run_callbacks()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if initialized:
			Steam.shutdown()


func _domain_changed(name: String):
	leaderboard = null
	Steam.findLeaderboard(name)


func _leaderboard_find_result(handle, found):
	assert found == 1
	leaderboard = handle
	# TODO: Try to dedupe
	Steam.downloadLeaderboardEntries(1, 1, LeaderboardDataRequest.Global)


func _ended(last_score):
	if initialized:
		# Retrieves only the top player
		Steam.downloadLeaderboardEntries(1, 1, LeaderboardDataRequest.Global)
		Steam.uploadLeaderboardScore(last_score, true)


func _leaderboard_scores_downloaded():
	var entries = Steam.getLeaderboardEntries()
	if entries.size() < 1:
		return
	var top = entries[0]
	var name = Steam.getFriendPersonaName(top["steamID"])
	var score = top["score"]
	Signals.emit_signal("top_changed", name, score)


func _leaderboard_score_uploaded(success, score, score_changed, global_rank_new, global_rank_previous):
	# TODO: Animate the rank transition with information here
	pass