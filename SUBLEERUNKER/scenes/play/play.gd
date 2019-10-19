extends Control

signal closed

const packed_standby = preload("session/standby/standby.tscn")
const packed_ingame = preload("session/ingame/ingame.tscn")

onready var viewport = find_node("Viewport")
onready var is_playing := false
onready var session: Node = null


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


func _on_started():
	_session_ingame()


func _on_ended(last_score):
	Signals.emit_signal("score_upload_requested", last_score)
	var result = yield(Signals, "score_upload_responded")
	_session_standby(result)


func _session_standby(last_result):
	_clear_session()
	session = packed_standby.instance()
	session.viewport = viewport
	add_child(session)


func _session_ingame():
	_clear_session()
	session = packed_ingame.instance()
	session.viewport = viewport
	add_child(session)


func _clear_session():
	if session:
		session.queue_free()
		session = null
	for child in viewport.get_children():
		child.queue_free()

