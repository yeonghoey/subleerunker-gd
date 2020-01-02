extends "res://main/scene/scene.gd"

const Stadium := preload("res://game/stadium/stadium.gd")
const Stage := preload("res://game/stage/stage.gd")
const Preset := preload("res://game/preset/preset.gd")
const Indicator := preload("res://main/scene/play/play_indicator.gd")

const ModeSel := preload("res://game/stage/modesel/modesel.tscn")
const Waiting := preload("res://game/stage/waiting/waiting.tscn")
const InGame := preload("res://game/stage/ingame/ingame.tscn")

signal backed()

var _last_mode := ""

var _preset: Preset

onready var _Stadium: Stadium = find_node("Stadium")
onready var _Indicator: Indicator = find_node("Indicator")


func init(last_mode: String) -> void:
	_last_mode = last_mode


func _ready():
	_present_modesel(_last_mode)


func _present_modesel(last_mode: String):
	var modesel := ModeSel.instance()
	modesel.init(last_mode)
	modesel.connect("selected", self, "_on_modesel_selected", [modesel])
	modesel.connect("canceled", self, "_on_modesel_canceled")
	_Stadium.present(modesel)


func _on_modesel_selected(mode_name: String, modesel: Stage):
	modesel.close()
	_preset = _load_preset(mode_name)
	_present_waiting()


func _on_modesel_canceled():
	emit_signal("backed")


func _present_waiting():
	var waiting := Waiting.instance()
	waiting.init(_preset)
	waiting.connect("started", self, "_on_waiting_started", [waiting])
	waiting.connect("canceled", self, "_on_waiting_canceled", [waiting])
	_Stadium.present(waiting)


func _on_waiting_started(waiting: Stage):
	waiting.close()
	_present_ingame()


func _on_waiting_canceled(waiting: Stage):
	waiting.close()
	_present_modesel(_preset.take("name"))


func _present_ingame():
	var ingame := InGame.instance()
	ingame.init(_preset)
	ingame.connect("started", self, "_on_ingame_started")
	ingame.connect("scored", self, "_on_ingame_scored")
	ingame.connect("combo_hit", self, "_on_ingame_combo_hit")
	ingame.connect("combo_missed", self, "_on_ingame_combo_missed")
	ingame.connect("player_hit", self, "_on_ingame_player_hit")
	ingame.connect("ended", self, "_on_ingame_ended", [ingame])
	_Stadium.present(ingame)
	_Indicator.display({score=true, combo=true})


func _on_ingame_started(initial_score: int, initial_n_combo: int) -> void:
	_Indicator.display({score=true, combo=true})
	_Indicator.update_score(initial_score)
	_Indicator.update_combo(initial_n_combo)


func _on_ingame_scored(score: int) -> void:
	_Indicator.update_score(score)


func _on_ingame_combo_hit(n_combo: int) -> void:
	_Indicator.update_combo(n_combo)


func _on_ingame_combo_missed(n_combo: int, last_n_combo:int) -> void:
	# TODO: extend this to show some effects depending on last_n_combo
	_Indicator.update_combo(n_combo)


func _on_ingame_player_hit(score_new: int) -> void:
	pass


func _on_ingame_ended(ingame: Stage) -> void:
	ingame.close()
	_Indicator.display({score=true, combo=false})
	_present_waiting()


func _load_preset(mode_name: String) -> Preset:
	return load("res://game/preset/%s.gd" % mode_name).new()