extends Control

signal closed

const packed_standby = preload("session/standby/standby.tscn")
const packed_ingame = preload("session/ingame/ingame.tscn")

onready var viewport = find_node("Viewport")
onready var is_playing := false
onready var session: Node = null


func _ready():
	connect_signals()
	session_standby()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("closed")


func connect_signals():
	Signals.connect("started", self, "on_started")
	Signals.connect("ended", self, "on_ended")


func on_started():
	session_ingame()


func on_ended(score):
	session_standby()


func session_standby():
	clear_session()
	session = packed_standby.instance()
	session.viewport = viewport
	add_child(session)


func session_ingame():
	clear_session()
	session = packed_ingame.instance()
	session.viewport = viewport
	add_child(session)


func clear_session():
	if session:
		session.queue_free()
		session = null
	for child in viewport.get_children():
		child.queue_free()

