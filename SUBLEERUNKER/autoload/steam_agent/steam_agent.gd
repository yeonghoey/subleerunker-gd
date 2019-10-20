extends Node

var handler: Node
var tasks := []
var running := false


func _ready():
	var ret = Steam.steamInit()
	if ret["status"] == 0:
		handler = preload("handler_steam.gd").new()
		add_child(handler)
	else:
		push_warning('Steam.steamInit() failed: %s' % ret)
		handler = preload("handler_dummy.gd").new()
		add_child(handler)


func _process(delta):
	if running:
		return
	if tasks.empty():
		return
	var task = tasks.pop_front()
	_run_task(task)


func fetch_myrecord(domain, caller, callback):
	_queue_task({
		method = "fetch_myrecord",
		args = [domain],
		caller = weakref(caller),
		callback = callback,
	})


func fetch_highscores(domain, caller, callback):
	_queue_task({
		method = "fetch_highscores",
		args = [domain],
		caller = weakref(caller),
		callback = callback,
	})


func upload_score(domain, score, caller, callback):
	_queue_task({
		method = "upload_score",
		args = [domain, score],
		caller = weakref(caller),
		callback = callback,
	})


func _queue_task(task: Dictionary):
	tasks.append(task)


func _run_task(task: Dictionary):
	running = true
	var ret = handler.callv(task["method"], task["args"])
	if ret is GDScriptFunctionState:
		ret = yield(ret, "completed")
	var caller = task["caller"].get_ref()
	if caller != null:
		caller.call(task["callback"], ret)
	running = false