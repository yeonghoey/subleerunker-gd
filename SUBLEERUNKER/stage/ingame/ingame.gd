extends "res://stage/stage.gd"

const Mode := preload("res://mode/mode.gd")
const Hero := preload("res://hero/hero.gd")
const HeroDying := preload("res://herodying/herodying.gd")
const Drop := preload("res://drop/drop.gd")
const DropSpawner := preload("res://dropspawner/dropspawner.gd")
const Pedal := preload("res://pedal/pedal.gd")
const PedalHitting := preload("res://pedalhitting/pedalhitting.gd")
const PedalMissing := preload("res://pedalmissing/pedalmissing.gd")
const PedalSpawner := preload("res://pedalspawner/pedalspawner.gd")
const BGM := preload("res://bgm/bgm.gd")
const Cam := preload("res://cam/cam.gd")

const Troupe := preload("troupe.gd")

signal started(initial_score, initial_n_combo)
signal scored(score)
signal combo_hit(n_combo)
signal combo_missed(n_combo, last_n_combo)
signal hero_hit(final_score)
signal ended()
signal lr_changed(left, right)

var _mode: Mode
var _bgm: BGM
var _cam: Cam
var _dropspawner: DropSpawner
var _pedalspawner: PedalSpawner
var _troupe: Troupe
var _hero: Hero

var _is_hero_hit := false
var _score := 0
var _n_combo := 1


func init(mode: Mode) -> void:
	_mode = mode


func _ready():
	assert(_mode != null)
	_add_bgm()
	_add_cam()
	_add_background()
	_add_dropspawner()
	_add_pedalspawner()
	_add_troupe()
	_cast_hero()
	_wire_input_to_hero()
	_wire_events_to_cam()
	_emit_started()


func _add_bgm() -> void:
	_bgm = _mode.make("BGM")
	add_child(_bgm)


func _add_cam() -> void:
	_cam = _mode.make("Cam")
	add_child(_cam)


func _add_background():
	var background := _mode.make("Background")
	add_child(background)


func _add_dropspawner():
	_dropspawner = _mode.make("DropSpawner")
	_dropspawner.connect("cued", self, "_on_dropspawner_cued")
	add_child(_dropspawner)


func _on_dropspawner_cued(hints) -> void:
	for hint in hints:
		_cast_drop(hint)


func _add_pedalspawner():
	_pedalspawner = _mode.make("PedalSpawner")
	_pedalspawner.connect("cued", self, "_on_pedalspawner_cued")
	add_child(_pedalspawner)


func _on_pedalspawner_cued(hints):
	for hint in hints:
		_cast_pedal(hint)


func _add_troupe():
	_troupe = Troupe.new()
	_troupe.connect("cleared", self, "_on_troup_cleared")
	add_child(_troupe)


func _on_troup_cleared():
	emit_signal("ended")


func _cast_hero():
	_hero = _mode.make("Hero")
	_hero.init(rect_size)
	_hero.connect("hit", _bgm, "queue_free")
	_hero.connect("hit", _cam, "queue_free")
	_hero.connect("hit", _dropspawner, "queue_free")
	_hero.connect("hit", _pedalspawner, "queue_free")
	_hero.connect("hit", self, "_on_hero_hit")
	_troupe.cast(_hero)


func _on_hero_hit():
	_is_hero_hit = true
	_cast_herodying(_hero)
	var final_score := _score
	emit_signal("hero_hit", final_score)


func _cast_herodying(hero: Hero):
	var herodying: HeroDying = _mode.make("HeroDying")
	herodying.init(hero)
	_troupe.cast(herodying)


func _cast_drop(hint):
	var drop: Drop = _mode.make("Drop")
	drop.init(rect_size, _hero, hint)
	drop.connect("landed", self, "_on_drop_landed", [drop])
	_dropspawner.on_drop_spawned(drop)
	_troupe.cast(drop)


func _on_drop_landed(drop: Drop) -> void:
	if _is_hero_hit:
		return
	_score += _n_combo
	emit_signal("scored", _score)


func _cast_pedal(hint) -> void:
	var pedal: Pedal = _mode.make("Pedal")
	pedal.init(rect_size, _hero, hint)
	pedal.connect("triggered", self, "_on_pedal_triggered", [pedal])
	pedal.connect("disappeared", self, "_on_pedal_disappeared", [pedal])
	_pedalspawner.on_pedal_spawned(pedal)
	_troupe.cast(pedal)


func _on_pedal_triggered(pedal: Pedal) -> void:
	if _is_hero_hit:
		return
	_n_combo += 1
	_cast_pedalhitting(pedal, _n_combo)
	emit_signal("combo_hit", _n_combo)


func _on_pedal_disappeared(pedal: Pedal) -> void:
	if _is_hero_hit:
		return
	var last_n_combo := _n_combo
	_n_combo = 1
	_cast_pedalmissing(pedal, last_n_combo)
	emit_signal("combo_missed", _n_combo, last_n_combo)


func _cast_pedalhitting(pedal: Pedal, n_combo: int) -> void:
	var pedalhitting: PedalHitting = _mode.make("PedalHitting")
	pedalhitting.init(pedal, n_combo)
	_troupe.cast(pedalhitting)


func _cast_pedalmissing(pedal: Pedal, last_n_combo: int) -> void:
	var pedalmissing: PedalMissing = _mode.make("PedalMissing")
	pedalmissing.init(pedal, last_n_combo)
	_troupe.cast(pedalmissing)


func _wire_input_to_hero() -> void:
	connect("lr_changed", _hero, "handle_action_input")


func _wire_events_to_cam() -> void:
	connect("started", _cam, "on_started")
	connect("scored", _cam, "on_scored")
	connect("combo_hit", _cam, "on_combo_hit")
	connect("combo_missed", _cam, "on_combo_missed")
	connect("hero_hit", _cam, "on_hero_hit")
	connect("ended", _cam, "on_ended")


func _emit_started() -> void:
	emit_signal("started", _score, _n_combo)


func _input(event):
	if event.is_action("ui_left") or event.is_action("ui_right"):
		emit_signal("lr_changed",
			Input.is_action_pressed("ui_left"),
			Input.is_action_pressed("ui_right"))
		return