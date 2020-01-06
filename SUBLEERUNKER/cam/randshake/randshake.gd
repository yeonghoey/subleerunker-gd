extends "res://cam/cam.gd"


func _ready():
	create_shake_animation("shake", 0.32, 0.02, 4.0)


func on_combo_missed(n_combo: int, last_n_combo: int) -> void:
	play("shake")