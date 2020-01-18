extends "res://cam/cam.gd"


func init(scorer: Scorer) -> void:
	scorer.connect("combo_missed", self, "_on_scorer_combo_missed")


func _ready():
	create_shake_animation("shake", 0.32, 0.02, 4.0)


func _on_scorer_combo_missed(last_combo: int) -> void:
	play("shake")