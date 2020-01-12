extends "res://pedalspawner/pedalspawner.gd"

export(PackedScene) var Pedal_: PackedScene

export(float) var cooltime_min
export(float) var cooltime_max

var _exists := false
var _cooltime := 0.0


func _ready():
	_reset()


func _physics_process(delta: float):
	if _exists:
		return
	if _cooltime > 0:
		_cooltime = max(_cooltime - delta, 0)
		return
	var pedal := Pedal_.instance()
	cue([pedal])
	_exists = true


func on_pedal_initialized(pedal: Pedal) -> void:
	pedal.connect("triggered", self, "_reset")
	pedal.connect("disappeared", self, "_reset")


func _reset():
	_exists = false
	_cooltime = _next_cooltime()


func _next_cooltime():
	var r = cooltime_max - cooltime_min
	return cooltime_min + (r * randf())