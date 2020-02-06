extends "res://stage/stage.gd"

const Mode := preload("res://mode/mode.gd")
const Scorer := preload("res://scorer/scorer.gd")
const Background := preload("res://background/background.gd")
const BGM := preload("res://bgm/bgm.gd")
const Cam := preload("res://cam/cam.gd")
const Drop := preload("res://drop/drop.gd")
const DropSpawner := preload("res://dropspawner/dropspawner.gd")
const Hero := preload("res://hero/hero.gd")
const Pedal := preload("res://pedal/pedal.gd")
const PedalSpawner := preload("res://pedalspawner/pedalspawner.gd")

const Troupe := preload("troupe.gd")

signal hero_hit(final_score)
signal ended()

var _mode: Mode
var _scorer: Scorer

var _background: Background
var _bgm: BGM
var _cam: Cam
var _troupe: Troupe
var _hero: Hero
var _dropspawner: DropSpawner
var _pedalspawner: PedalSpawner

var _is_hero_hit := false


func init(mode: Mode, scorer: Scorer) -> void:
	_mode = mode
	_scorer = scorer

	_background = _mode.make("Background")
	add_child(_background)

	_bgm = _mode.make("BGM")
	add_child(_bgm)

	_cam = _mode.make("Cam")
	_cam.init(_scorer)
	add_child(_cam)

	_troupe = Troupe.new()
	add_child(_troupe)

	_hero = _mode.make("Hero")
	var starting_pos := _background.hero_starting_pos(_hero.size)
	_hero.init(starting_pos)
	_troupe.cast(_hero)

	_dropspawner = _mode.make("DropSpawner")
	_dropspawner.init(_scorer, _background, _hero)
	add_child(_dropspawner)

	_pedalspawner = _mode.make("PedalSpawner")
	_pedalspawner.init(_scorer, _background, _hero)
	add_child(_pedalspawner)


func _ready():
	_wire_signals()
	_start()


func _wire_signals() -> void:
	_dropspawner.connect("cued", self, "_on_spawner_cued")
	_pedalspawner.connect("cued", self, "_on_spawner_cued")
	_hero.connect("hit", self, "_on_hero_hit")
	_troupe.connect("cleared", self, "_on_troup_cleared")


func _on_spawner_cued(actors: Array) -> void:
	for actor in actors:
		assert((actor is Drop) or (actor is Pedal))
		_troupe.cast(actor)


func _on_hero_hit():
	_is_hero_hit = true

	_bgm.queue_free()
	_cam.queue_free()
	_dropspawner.queue_free()
	_pedalspawner.queue_free()

	var final_score := _scorer.freeze()
	emit_signal("hero_hit", final_score)


func _on_troup_cleared():
	emit_signal("ended")


func _start() -> void:
	_scorer.initialize()
