extends Node

const Leaderboard := preload("res://game/view/leaderboard.tscn")

onready var _preset := GamePreset.of("subleerunker")


func _ready():
	_refresh({})


func _on_Button_toggled(button_pressed: bool):
	if button_pressed:
		_refresh({
			rank_old=1000, 
			rank_new=234, 
			score_old=12323, 
			score_new=45624})
	else:
		_refresh({})


func _refresh(myrecord_break: Dictionary):
	var leaderboard = Leaderboard.instance()
	leaderboard.init(_preset, myrecord_break)
	$Frame.display(leaderboard)