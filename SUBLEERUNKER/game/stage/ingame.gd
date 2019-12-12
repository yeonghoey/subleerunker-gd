extends "res://game/stage/stage.gd"

const Preset := preload("res://game/preset/preset.gd")
const Troupe := preload("res://game/stage/ingame_troupe.gd")
const Hero := preload("res://game/hero/hero.gd")
const HeroDying := preload("res://game/herodying/herodying.gd")
const Drop := preload("res://game/drop/drop.gd")
const DropLanding := preload("res://game/droplanding/droplanding.gd")
const DropSpawner := preload("res://game/dropspawner/dropspawner.gd")
const Pedal := preload("res://game/pedal/pedal.gd")
const PedalHitting := preload("res://game/pedalhitting/pedalhitting.gd")
const PedalMissing := preload("res://game/pedalmissing/pedalmissing.gd")
const PedalSpawner := preload("res://game/pedalspawner/pedalspawner.gd")

signal lr_changed(left, right)
signal scored(score)
signal combo_hit(n_combo)
signal combo_missed(last_n_combo)
signal player_hit()
signal ended()

var _preset: Preset

var _dropspawner: DropSpawner
var _pedalspawner: PedalSpawner
var _troupe: Troupe
var _hero: Hero

var _is_hero_hit := false
var _score := 0
var _n_combo := 1


func init(preset: Preset) -> void:
	_preset = preset


func _ready():
	assert(_preset != null)
	_add_background()
	_add_dropspawner()
	_add_pedalspawner()
	_add_troupe()
	_cast_hero()
	_wire_input_to_hero()


func _add_background():
	var background := _preset.make("Background")
	add_child(background)


func _add_dropspawner():
	_dropspawner = _preset.make("DropSpawner")
	_dropspawner.connect("cued", self, "_on_dropspawner_cued")
	add_child(_dropspawner)


func _on_dropspawner_cued(hints) -> void:
	for hint in hints:
		_cast_drop(hint)


func _add_pedalspawner():
	_pedalspawner = _preset.make("PedalSpawner")
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
	queue_free()


func _cast_hero():
	_hero = _preset.make("Hero")
	_hero.init(rect_size)
	_hero.connect("hit", _dropspawner, "queue_free")
	_hero.connect("hit", _pedalspawner, "queue_free")
	_hero.connect("hit", self, "_on_hero_hit")
	_troupe.cast(_hero)


func _on_hero_hit():
	_is_hero_hit = true
	_cast_herodying(_hero)
	emit_signal("player_hit")


func _cast_herodying(hero: Hero):
	var herodying: HeroDying = _preset.make("HeroDying")
	herodying.init(hero)
	_troupe.cast(herodying)


func _cast_drop(hint):
	var drop: Drop = _preset.make("Drop")
	drop.init(rect_size, _hero, hint)
	drop.connect("landed", self, "_on_drop_landed", [drop])
	_dropspawner.on_drop_spawned(drop)
	_troupe.cast(drop)
	

func _on_drop_landed(drop: Drop) -> void:
	_cast_droplanding(drop)
	if _is_hero_hit:
		return
	_score += _n_combo
	emit_signal("scored", _score)


func _cast_droplanding(drop: Drop) -> void:
	var droplanding: DropLanding = _preset.make("DropLanding")
	droplanding.init(drop)
	_troupe.cast(droplanding)


func _cast_pedal(hint) -> void:
	var pedal: Pedal = _preset.make("Pedal")
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
	emit_signal("combo_missed", last_n_combo)


func _cast_pedalhitting(pedal: Pedal, n_combo: int) -> void:
	var pedalhitting: PedalHitting = _preset.make("PedalHitting")
	pedalhitting.init(pedal, n_combo)
	_troupe.cast(pedalhitting)


func _cast_pedalmissing(pedal: Pedal, last_n_combo: int) -> void:
	var pedalmissing: PedalMissing = _preset.make("PedalMissing")
	pedalmissing.init(pedal, last_n_combo)
	_troupe.cast(pedalmissing)


func _wire_input_to_hero():
	connect("lr_changed", _hero, "handle_action_input")


func _input(event):
	if event.is_action("ui_left") or event.is_action("ui_right"):
		emit_signal("lr_changed", 
			Input.is_action_pressed("ui_left"),
			Input.is_action_pressed("ui_right"))
		return