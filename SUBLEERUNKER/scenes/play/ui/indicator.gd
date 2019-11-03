extends MarginContainer


onready var _label_score = find_node("Score")
onready var _label_combo = find_node("Combo")


func _ready():
	_label_score.text = "0"
	Signals.connect("started", self, "_on_started")
	Signals.connect("ended", self, "_on_ended")
	Signals.connect("scored", self, "on_scored")


func _on_started(best_score):
	_label_combo.visible = true


func _on_ended(result):
	_label_combo.visible = false


func on_scored(score, n_combo):
	_label_score.text = String(score)
	_label_combo.text = "x%d" % n_combo