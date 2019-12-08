extends GameFactory


func _init().({
	background = preload("res://game/background/black.tscn"),
	hero = preload("res://game/hero/sublee.tscn"),
	dying = preload("res://game/dying/burning.tscn"),
	drop = preload("res://game/drop/flame.tscn"),
	landing = preload("res://game/landing/dispersing.tscn"),
	pedal = preload("res://game/pedal/yellowbar.tscn"),
	labelcolor = Color("#ffffff"),
}):
    pass