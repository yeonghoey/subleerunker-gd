extends "res://game/dropspawner/dropspawner.gd"

export(float) var initial_spawn_per_sec
export(float) var increase_speed_per_sec
export(float) var increase_accel_per_sec
export(int) var num_drops_per_cue

var _spawn_per_sec: float


func _ready():
	_spawn_per_sec = initial_spawn_per_sec


func _physics_process(delta):
	increase_speed_per_sec += increase_accel_per_sec * delta
	_spawn_per_sec += increase_speed_per_sec * delta
	var threshold = _spawn_per_sec * delta
	if randf() < threshold:
		var hints := []
		hints.resize(num_drops_per_cue)
		cue(hints)