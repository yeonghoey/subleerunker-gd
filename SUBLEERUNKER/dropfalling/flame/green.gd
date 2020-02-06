extends "res://dropfalling/flame/flame.gd"

const PARAMS := {
	true: {
		"min": 0.3,
		"max": 0.6,
		"modulate": Color(1.0, 1.0, 1.0, 1.0),
	},
	false: {
		"min": 0.1,
		"max": 0.2,
		"modulate": Color(1.0, 1.0, 1.0, 0.05),
	}
}

var _visible := true

onready var _Sprite: Sprite = $Sprite
onready var _Tween: Tween = $Tween


func _ready():
	_Tween.connect("tween_completed", self, "_on_tween_completed")
	_reset(false)


func _on_tween_completed(object: Object, key: NodePath) -> void:
	_reset(!_visible)


func _reset(v: bool) -> void:
	_Tween.interpolate_property(_Sprite, "modulate",
		PARAMS[!v]["modulate"], PARAMS[v]["modulate"],
		_rand_duration(PARAMS[v]["min"], PARAMS[v]["max"]),
		Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	_Tween.start()
	_visible = v


func _rand_duration(min_: float, max_: float) -> float:
	var r = max_ - min_
	return max_ + (r * randf())
