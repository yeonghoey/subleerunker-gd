extends Control

const Leaderboard := preload("res://game/stage/leaderboard.tscn")

onready var _preset := preload("res://game/preset/subleerunker.gd").new()


func _ready():
	_refresh({})


func _on_Button_toggled(button_pressed: bool):
	if button_pressed:
		_refresh({
			rank_new=234,
			rank_old=1000, 
			score_new=45624,
			score_old=12323, 
		})
	else:
		_refresh({})


func _refresh(myrecord_break: Dictionary):
	var leaderboard = Leaderboard.instance()
	leaderboard.init(_preset, myrecord_break)
	leaderboard.connect("started", self, "_echo1", ["started"])
	leaderboard.connect("canceled", self, "_echo0", ["canceled"])
	$Stadium.present(leaderboard)


func _echo0(s):
	print("%s()" % s)


func _echo1(a, s):
	print("%s(%s)" % [s, a])
	