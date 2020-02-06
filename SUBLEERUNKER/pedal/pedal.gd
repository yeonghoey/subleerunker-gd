extends Node

const Hero := preload("res://hero/hero.gd")
const Scorer := preload("res://scorer/scorer.gd")
const PedalActive := preload("res://pedalactive/pedalactive.gd")
const PedalHitting := preload("res://pedalhitting/pedalhitting.gd")
const PedalMissing := preload("res://pedalmissing/pedalmissing.gd")

export(PackedScene) var PedalActive_: PackedScene
export(Vector2) var size: Vector2

signal hit()
signal missed()


func init(scorer: Scorer, starting_pos: Vector2) -> void:
	var pedalactive: PedalActive = PedalActive_.instance()
	pedalactive.position = starting_pos
	pedalactive.connect("tree_exiting", self, "_on_pedalactive_tree_exiting", [scorer, pedalactive])
	add_child(pedalactive)


func _on_pedalactive_tree_exiting(scorer: Scorer, pedalactive: PedalActive) -> void:
	if pedalactive.is_hit:
		_on_pedalactive_hit(scorer, pedalactive)
	else:
		_on_pedalactive_missed(scorer, pedalactive)


func _on_pedalactive_hit(scorer: Scorer, pedalactive: PedalActive) -> void:
	var combo := scorer.hit_combo()
	if combo == Scorer.FREEZED:
		queue_free()
		return
	var pedalhitting: PedalHitting = pedalactive.make_pedalhitting(combo)
	pedalhitting.connect("tree_exiting", self, "queue_free")
	add_child(pedalhitting)
	emit_signal("hit")


func _on_pedalactive_missed(scorer: Scorer, pedalactive: PedalActive):
	var last_combo := scorer.miss_combo()
	if last_combo == Scorer.FREEZED:
		queue_free()
		return
	var pedalmissing: PedalMissing = pedalactive.make_pedalmissing(last_combo)
	pedalmissing.connect("tree_exiting", self, "queue_free")
	add_child(pedalmissing)
	emit_signal("missed")
