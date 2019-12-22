extends MarginContainer

const InGame := preload("res://game/stage/ingame.gd")

onready var _controls := {
	score = find_node("Score"),
	combo = find_node("Combo"),
}


func _ready():
	visible = false


func display(d: Dictionary) -> void:
	"""Take a dictionary of {name: visibility} pairs and apply it.
	"""
	var visible_any := false
	for k in d:
		var v: bool = d[k]
		_controls[k].visible = v
		visible_any = visible_any or v
	visible = visible_any


func update_score(score: int) -> void:
	_controls["score"].text = String(score)


func update_combo(n_combo: int) -> void:
	_controls["combo"].text = "x%d" % n_combo