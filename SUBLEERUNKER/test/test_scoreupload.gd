extends Control

const ScoreUpload := preload("res://game/stage/scoreupload.tscn")

onready var _preset := preload("res://game/preset/subleerunker.gd").new()


func _ready():
	_restart()


func _restart():
	var scoreupload = ScoreUpload.instance()
	scoreupload.init(_preset, 0, 21)
	add_child(scoreupload)