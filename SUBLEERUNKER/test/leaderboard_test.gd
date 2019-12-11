extends Node

onready var _preset := GamePreset.of("subleerunker")
onready var _packed_leaderboard := preload("res://game/view/leaderboard.tscn")


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
	var leaderboard = _packed_leaderboard.instance()
	leaderboard.init(_preset, myrecord_break)
	$Frame.display(leaderboard)