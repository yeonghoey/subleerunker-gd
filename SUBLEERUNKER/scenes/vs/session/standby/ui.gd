extends Control

var _player_num := 0


func init(player_num: int):
	_player_num = player_num


func _ready():
	var label = find_node("Label")
	label.text = "PLAYER %d" % _player_num
	_connect_signals()


func _connect_signals():
	Signals.connect("scene_vs_game_started", self, "_on_scene_vs_game_started")


func _on_scene_vs_game_started():
	queue_free()