extends "res://scene/scene.gd"

const Modebox := preload("res://modebox/modebox.gd")
const Statbox := preload("res://statbox/statbox.gd")

const Mode := preload("res://mode/mode.gd")
const Stadium := preload("res://stadium/stadium.gd")
const Stage := preload("res://stage/stage.gd")
const Indicator := preload("res://scene/play/play_indicator.gd")

const ModeSel := preload("res://stage/modesel/modesel.tscn")
const Waiting := preload("res://stage/waiting/waiting.tscn")
const InGame := preload("res://stage/ingame/ingame.tscn")

signal backed()

var _modebox: Modebox
var _statbox: Statbox

onready var _Stadium: Stadium = find_node("Stadium")
onready var _Indicator: Indicator = find_node("Indicator")


func init(modebox: Modebox, statbox: Statbox) -> void:
	_modebox = modebox
	_statbox = statbox


func _ready():
	_present_modesel()


func _present_modesel():
	var modesel := ModeSel.instance()
	var catalog := _compile_catalog()
	modesel.init(catalog)
	modesel.connect("selected", self, "_on_modesel_selected", [modesel])
	modesel.connect("canceled", self, "_on_modesel_canceled", [modesel])
	_Stadium.present(modesel)


func _compile_catalog() -> Array:
	var last_mode := _modebox.get_selected()
	var catalog := []
	for mode in _modebox.list():
		catalog.append({
			name = mode.take("name"),
			# TODO: implement flags
			icon = mode.take("icon_on"),
			is_unlocked = true,
			is_last = (mode == last_mode),
			is_new = false,
		})
	return catalog


func _on_modesel_selected(name: String, modesel: Stage):
	modesel.close()
	_modebox.select(name)
	_present_waiting()


func _on_modesel_canceled(modesel: Stage):
	modesel.close()
	request_ready()
	emit_signal("backed")


func _present_waiting():
	var waiting := Waiting.instance()
	var mode := _modebox.get_selected()
	waiting.init(mode)
	waiting.connect("started", self, "_on_waiting_started", [waiting])
	waiting.connect("canceled", self, "_on_waiting_canceled", [waiting])
	_Stadium.present(waiting)


func _on_waiting_started(waiting: Stage):
	waiting.close()
	_present_ingame()


func _on_waiting_canceled(waiting: Stage):
	waiting.close()
	_present_modesel()


func _present_ingame():
	var ingame := InGame.instance()
	var mode := _modebox.get_selected()
	ingame.init(mode)
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