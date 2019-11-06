extends MarginContainer

onready var _label_score = find_node("Score")
onready var _label_combo = find_node("Combo")


func _ready():
	_connect_signals()
	# Reset
	_on_scored(0)
	_on_game_combo_updated(1)


func _connect_signals():
	Signals.connect("started", self, "_on_started")
	Signals.connect("ended", self, "_on_ended")
	Signals.connect("scored", self, "_on_scored")
	Signals.connect("game_combo_updated", self, "_on_game_combo_updated")


func _on_started(best_score):
	_label_combo.visible = true


func _on_ended(result):
	_label_combo.visible = false


func _on_scored(score):
	_label_score.text = String(score)


func _on_game_combo_updated(n_combo):
	_label_combo.text = "x%d" % n_combo