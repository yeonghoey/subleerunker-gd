extends Control

const _packed_standby = preload("session/standby/standby.tscn")
const _packed_ingame = preload("session/ingame/ingame.tscn")

onready var _viewport_p1 = find_node("P1").find_node("Viewport")
onready var _viewport_p2 = find_node("P2").find_node("Viewport")


func _ready():
	_connect_signals()
	Signals.emit_signal("scene_vs_game_ended")


func _connect_signals():
	Signals.connect("scene_vs_game_started", self, "_on_scene_vs_game_started")
	Signals.connect("scene_vs_game_ended", self, "_on_scene_vs_game_ended")


func _on_scene_vs_game_started():
	_start_game()


func _start_game():
	var ingame = _packed_ingame.instance()
	ingame.init({"p1": _viewport_p1, "p2": _viewport_p2})
	add_child(ingame)


func _on_scene_vs_game_ended():
	_standby_game()


func _standby_game():
	var standby = _packed_standby.instance()
	standby.init(_viewport_p1, _viewport_p2)
	add_child(standby)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Signals.emit_signal("scene_play_closed")