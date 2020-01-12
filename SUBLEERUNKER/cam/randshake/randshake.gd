extends "res://cam/cam.gd"


func _ready():
	create_shake_animation("shake", 0.32, 0.02, 4.0)


func on_scorer_combo_missed(last_combo: int) -> void:
	play("shake")