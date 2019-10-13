extends Control

signal closed


onready var viewport = find_node("Viewport")
const packed_session = preload("res://game/session/session_play.tscn")


func _ready():
	var session = packed_session.instance()
	session.viewport = viewport
	add_child(session)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("closed")