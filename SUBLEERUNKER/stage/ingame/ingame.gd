extends "res://stage/stage.gd"

const Mode := preload("res://mode/mode.gd")
const Scorer := preload("res://scorer/scorer.gd")
const Background := preload("res://background/background.gd")
const Hero := preload("res://hero/hero.gd")
const Drop := preload("res://drop/drop.gd")
const DropSpawner := preload("res://dropspawner/dropspawner.gd")
const Pedal := preload("res://pedal/pedal.gd")
const PedalSpawner := preload("res://pedalspawner/pedalspawner.gd")
const BGM := preload("res://bgm/bgm.gd")
const Cam := preload("res://cam/cam.gd")
const Troupe := preload("troupe.gd")

signal hero_hit(final_score)
signal ended()

var _mode: Mode
var _scorer: Scorer

var _bgm: BGM
var _cam: Cam
var _background: Background
var _dropspawner: DropSpawner
var _pedalspawner: PedalSpawner
var _troupe: Troupe
var _hero: Hero

var _is_hero_hit := false


func init(mode: Mode, scorer: Scorer) -> void:
	_mode = mode
	_scorer = scorer


func _ready():
	assert(_mode != null)
	_add_bgm()
	_add_cam()
	_add_background()
	_add_dropspawner()
	_add_pedalspawner()
	_add_troupe()
	_cast_hero()
	_wire_events_to_cam()
	_start()


func _add_bgm() -> void:
	_bgm = _mode.make("BGM")
	add_child(_bgm)


func _add_cam() -> void:
	_cam = _mode.make("Cam")
	add_child(_cam)


func _add_background():
	_background = _mode.make("Background")
	add_child(_background)


func _add_dropspawner():
	_dropspawner = _mode.make("DropSpawner")
	_dropspawner.connect("cued", self, "_on_dropspawner_cued")
	add_child(_dropspawner)


func _on_dropspawner_cued(drops: Array) -> void:
	for drop in drops:
		_cast_drop(drop)


func _add_pedalspawner():
	_pedalspawner = _mode.make("PedalSpawner")
	_pedalspawner.connect("cued", self, "_on_pedalspawner_cued")
	add_child(_pedalspawner)


func _on_pedalspawner_cued(pedals: Array) -> void:
	for pedal in pedals:
		_cast_pedal(pedal)


func _add_troupe():
	_troupe = Troupe.new()
	_troupe.connect("cleared", self, "_on_troup_cleared")
	add_child(_troupe)


func _on_troup_cleared():
	emit_signal("ended")


func _cast_hero():
	_hero = _mode.make("Hero")
	_hero.init(_background)
	_hero.connect("hit", _bgm, "queue_free")
	_hero.connect("hit", _cam, "queue_free")
	_hero.connect("hit", _dropspawner, "queue_free")
	_hero.connect("hit", _pedalspawner, "queue_free")
	_hero.connect("hit", self, "_on_hero_hit")
	_troupe.cast(_hero)


func _on_hero_hit():
	_is_hero_hit = true
	var final_score := _scorer.freeze()
	emit_signal("hero_hit", final_score)


func _cast_drop(drop: Drop) -> void:
	drop.init(rect_size, _hero, _scorer)
	_dropspawner.on_drop_initialized(drop)
	_troupe.cast(drop)


func _cast_pedal(pedal: Pedal) -> void:
	pedal.init(rect_size, _hero, _scorer)
	_pedalspawner.on_pedal_initialized(pedal)
	_troupe.cast(pedal)


func _wire_events_to_cam() -> void:
	_scorer.connect("initialized", _cam, "on_scorer_initialized")
	_scorer.connect("scored", _cam, "on_scorer_scored")
	_scorer.connect("combo_hit", _cam, "on_scorer_combo_hit")
	_scorer.connect("combo_missed", _cam, "on_scorer_combo_missed")
	connect("hero_hit", _cam, "on_ingame_hero_hit")
	connect("ended", _cam, "on_ingame_ended")


func _start() -> void:
	_scorer.initialize()