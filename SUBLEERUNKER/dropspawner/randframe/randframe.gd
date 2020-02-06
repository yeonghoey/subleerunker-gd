extends "res://dropspawner/dropspawner.gd"

export(PackedScene) var Drop_: PackedScene

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
		var drops := []
		for i in range(num_drops_per_cue):
			var drop: Drop = packed_drop().instance()
			var starting_pos := rand_pos(drop.size)
			drop.init(get_scorer(), starting_pos)
			drops.append(drop)
		cue(drops)


func packed_drop() -> PackedScene:
	return Drop_
