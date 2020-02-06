extends Node
"""Subclasses of this should call cue() when they decided to spawn actors,
node instances which will be added under ingame/troupe.

The signal argument 'actors' should be array, each element of which
is an actor instance.
"""

const Scorer := preload("res://scorer/scorer.gd")
const Background := preload("res://background/background.gd")
const Hero := preload("res://hero/hero.gd")

signal cued(actors)

var _scorer: Scorer
var _background: Background
var _hero: Hero


func init(scorer: Scorer, background: Background, hero: Hero) -> void:
	"""Arguments will be kept and accessed by their own getter functions
	when subclasses decide where to spawn gameobjects.
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


func cue(actors: Array) -> void:
	emit_signal("cued", actors)


func rand_pos(size: Vector2, at_bottom: bool = false) -> Vector2:
	"""Sample a rand pos based on the size and play_area in Background.

	This is a utility function for subclasses.
	"""
	var area: Rect2 = _background.play_area()
	var w := size.x
	var h := size.y
	#+----------------------------
	#          <---     b     --->
	# <-- a -->[w/2]    *    [w/2]
	#          <-- c -->^
	# <---    x     --->|
	var a := area.position.x
	var b := area.size.x
	var c := (b - w) * randf() + w/2
	var x := a + c
	var y := -h/2
	if at_bottom:
		y += area.end.y
	return Vector2(x, y)
