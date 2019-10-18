extends Node

enum LeaderboardDataRequest {
	Global = 0,
	GlobalAroundUser = 1,
	Friends = 2,
}


func _ready():
	var err = _try_init()
	if err == OK:
		_connect_signals()
	else:
		queue_free()


func _process(delta):
	Steam.run_callbacks()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Steam.shutdown()


func _try_init():
	var ret = Steam.steamInit()
	if ret["status"] == 0:
		return OK
	else:
		push_warning('Steam.steamInit() failed: %s' % ret)
		return FAILED


func _connect_signals():
	Signals.connect("steamagent_highscores_request", self, "_on_steamagent_highscores_request")


func _on_steamagent_highscores_request(domain):
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
	Signals.emit_signal("steamagent_highscores_response", entries)