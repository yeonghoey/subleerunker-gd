extends Control

var _player_num := 0


func init(player_num: int):
	_player_num = player_num


func _ready():
	var label_player = find_node("Player")
	label_player.text = "PLAYER %d" % _player_num
	var label_presskey = find_node("PressKey")
	if _player_num == 1:
		label_presskey.text = "Press [A] or [D]"
	else:
		label_presskey.text = "Press [<] or [>]"
	_connect_signals()


func _connect_signals():
	Signals.connect("scene_vs_game_started", self, "_on_scene_vs_game_started")


func _on_scene_vs_game_started():
	queue_free()