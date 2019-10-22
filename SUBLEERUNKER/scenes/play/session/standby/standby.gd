extends Node

var viewport: Viewport
var last_result := {}

var myrecord_fetched := false
var myrecord := {}
var signaled := false

onready var background = preload("res://game/background/default/background.tscn").instance()
onready var view = preload("view/view.tscn").instance()


func _ready():
	viewport.add_child(background)
	viewport.add_child(view)
	SteamAgent.fetch_myrecord("default", self, "_on_fetch_myrecord")


func _unhandled_input(event):
	var pressed := (
		Input.is_action_pressed("ui_left") or 
		Input.is_action_pressed("ui_right"))

	if pressed and myrecord_fetched and not signaled:
		Signals.emit_signal("started", myrecord)
		signaled = true


func _on_fetch_myrecord(entries):
	myrecord_fetched = true
	myrecord = {rank = 0, score = 0}
	if entries.size() == 1:
		var entry = entries[0]
		myrecord["score"] = entry["score"]
		myrecord["rank"] = entry["global_rank"]
	view.update_myrecord(myrecord, last_result)
	SteamAgent.fetch_highscores("default", self, "_on_fetch_highscores")


func _on_fetch_highscores(entries):
	view.update_highscores(entries)