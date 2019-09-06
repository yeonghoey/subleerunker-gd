extends Node

func _ready():
	apply_bus_layout()
	connect_signals()

func apply_bus_layout():
	var layout = preload("res://audio/layout.tres")
	AudioServer.set_bus_layout(layout)

func connect_signals():
	Signals.connect("started", self, "on_started")
	Signals.connect("walk_begin", self, "on_walk_begin")
	Signals.connect("walk_end", self, "on_walk_end")
	Signals.connect("hit", self, "on_hit")

func on_started():
	$StreamBGM.play()

func on_walk_begin():
	$StreamWalk.play()

func on_walk_end():
	$StreamWalk.stop()

func on_hit(player):
	$StreamBGM.stop()
	$StreamWalk.stop()