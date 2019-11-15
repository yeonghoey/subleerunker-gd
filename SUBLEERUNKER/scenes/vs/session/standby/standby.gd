extends Node

const _packed_ui := preload("ui.tscn")

var _p1_view: Viewport
var _p2_view: Viewport


func init(p1_view: Viewport, p2_view: Viewport):
	_p1_view = p1_view
	_p2_view = p2_view


func _ready():
	_add_ui(1, _p1_view)
	_add_ui(2, _p2_view)


func _add_ui(player_num: int, view: Viewport):
	var ui = _packed_ui.instance()
	ui.init(player_num)
	view.add_child(ui)


func _unhandled_input(event):
	var p1_ready := (
		Input.is_action_pressed("vs_p1_left") or 
		Input.is_action_pressed("vs_p1_right"))
	
	var p2_ready := (
		Input.is_action_pressed("vs_p2_left") or 
		Input.is_action_pressed("vs_p2_right"))

	if p1_ready and p2_ready:
		_start_game()


func _start_game():
	Signals.emit_signal("scene_vs_game_started")
	queue_free()