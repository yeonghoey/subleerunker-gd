extends Control

signal closed

const packed_loading = preload("loading/loading.tscn")
const packed_standby = preload("session/standby/standby.tscn")
const packed_ingame = preload("session/ingame/ingame.tscn")

onready var viewport = find_node("Viewport")
onready var is_playing := false
onready var session: Node = null
onready var cached_best := -1


func _ready():
	_connect_signals()
	var last_score = 0
	Signals.emit_signal("ended", last_score)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("closed")


func _connect_signals():
	Signals.connect("started", self, "_on_started")
	Signals.connect("ended", self, "_on_ended")


func _on_started(myrecord):
	_session_ingame(myrecord)


func _on_ended(result):
	_session_standby(result)


func _show_loading():
	_clear_session()
	viewport.add_child(packed_loading.instance())


func _session_standby(last_result):
	_clear_session()
	session = packed_standby.instance()
	session.viewport = viewport
	add_child(session)


func _session_ingame(myrecord: Dictionary):
	_clear_session()
	session = packed_ingame.instance()
	session.viewport = viewport
	session.myrecord = myrecord
	add_child(session)


func _clear_session():
	if session:
		session.queue_free()
		session = null
	for child in viewport.get_children():
		child.queue_free()

