extends Node

var _player
var _action_left: String
var _action_right: String


func _init(player, px: String):
	_player = player
	_action_left = "vs_%s_left" % px
	_action_right = "vs_%s_right" % px


func _unhandled_input(event):
	var left = Input.is_action_pressed(_action_left)
	var right = Input.is_action_pressed(_action_right)
	_player.update_action(left, right)