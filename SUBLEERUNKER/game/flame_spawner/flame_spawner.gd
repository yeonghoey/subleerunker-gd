extends Node

var _spawn_per_sec = 5
var _increase_speed_per_sec = 0.0
var _increase_accel_per_sec = 0.005


func _ready():
	_connect_signals()


func _connect_signals():
	Signals.connect("hit", self, "_on_hit")


func _on_hit(px, player):
	queue_free()


func _physics_process(delta):
	_increase_speed_per_sec += _increase_accel_per_sec * delta
	_spawn_per_sec += _increase_speed_per_sec * delta

	var threshold = _spawn_per_sec * delta
	if randf() < threshold:
		Signals.emit_signal("game_flame_spawned")