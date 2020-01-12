extends Node

const Hero := preload("res://hero/hero.gd")
const Scorer := preload("res://scorer/scorer.gd")
const PedalActive := preload("res://pedalactive/pedalactive.gd")
const PedalHitting := preload("res://pedalhitting/pedalhitting.gd")
const PedalMissing := preload("res://pedalmissing/pedalmissing.gd")

export(PackedScene) var PedalActive_: PackedScene
export(PackedScene) var PedalHitting_: PackedScene
export(PackedScene) var PedalMissing_: PackedScene

signal triggered()
signal disappeared()


func init(boundary: Vector2, hero: Hero, scorer: Scorer, hint = null) -> void:
	var pedalactive: PedalActive = PedalActive_.instance()
	pedalactive.init(boundary, hero, hint)
	pedalactive.connect("tree_exiting", self, "_on_pedalactive_tree_exiting", [pedalactive, scorer])
	add_child(pedalactive)


func _on_pedalactive_tree_exiting(pedalactive: PedalActive, scorer: Scorer) -> void:
	if pedalactive.triggered:
		_on_pedalactive_triggered(pedalactive, scorer)
	else:
		_on_pedalactive_disappeared(pedalactive, scorer)


func _on_pedalactive_triggered(pedalactive: PedalActive, scorer: Scorer) -> void:
	var combo := scorer.hit_combo()
	if combo == Scorer.FREEZED:
		queue_free()
		return
	var pedalhitting: PedalHitting = PedalHitting_.instance()
	pedalhitting.init(pedalactive, combo)
	pedalhitting.connect("tree_exiting", self, "queue_free")
	add_child(pedalhitting)
	emit_signal("triggered")


func _on_pedalactive_disappeared(pedalactive: PedalActive, scorer: Scorer):
	var last_combo := scorer.miss_combo()
	if last_combo == Scorer.FREEZED:
		queue_free()
		return
	var pedalmissing: PedalMissing = PedalMissing_.instance()
	pedalmissing.init(pedalactive, last_combo)
	pedalmissing.connect("tree_exiting", self, "queue_free")
	add_child(pedalmissing)
	emit_signal("disappeared")