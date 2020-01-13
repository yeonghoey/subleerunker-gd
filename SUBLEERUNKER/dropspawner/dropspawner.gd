extends Node
"""Subclasses of this should call cue()' when they decided to spawn a Drop.

The signal argument 'drops' should be array, each element of which
is a new Drop instance.
"""

const Scorer := preload("res://scorer/scorer.gd")
const Background := preload("res://background/background.gd")
const Hero := preload("res://hero/hero.gd")
const Drop := preload("res://drop/drop.gd")

signal cued(drops)

var _scorer: Scorer
var _background: Background
var _hero: Hero


func init(scorer: Scorer, background: Background, hero: Hero) -> void:
	"""Arguments will be kept and accessed by their own getter functions
	when subclasses decide where to put drops.
	"""
	_scorer = scorer
	_background = background
	_hero = hero


func get_scorer() -> Scorer:
	return _scorer


func get_background() -> Background:
	return _background


func get_hero() -> Hero:
	return _hero


func cue(drops: Array) -> void:
	emit_signal("cued", drops)