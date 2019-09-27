extends Node


var initialized := false


func init():
	var ret = Steam.steamInit()
	if ret["status"] == 0:
		initialized = true
	else:
		push_warning('Steam.steamInit() failed: %s' % ret)


func shutdown():
	Steam.shutdown()