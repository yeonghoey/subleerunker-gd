extends Node


func _ready():
	var ret = Steam.steamInit()
	if ret["status"] == 0:
		add_child(preload("steam_handler.gd").new())
	else:
		push_warning('Steam.steamInit() failed: %s' % ret)
		add_child(preload("dummy_handler.gd").new())