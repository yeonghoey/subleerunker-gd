extends Control

signal play
signal vs
signal achievements
signal options


onready var menuitem_play = {
	label = find_node("MenuItemPlay"), 
	signal_name = "play",
}
onready var menuitem_vs = {
	label = find_node("MenuItemVS"),
	signal_name = "vs",
}
onready var menuitem_achievements = {
	label = find_node("MenuItemAchievements"),
	signal_name = "achievements",
}
onready var menuitem_options = {
	label = find_node("MenuItemOptions"),
	signal_name = "options",
}
onready var menu_layout = [
	[menuitem_play, menuitem_vs],
	[menuitem_achievements, menuitem_achievements],
	[menuitem_options, menuitem_options],
]

var sel_x := 0
var sel_y := 0
var sel_style = preload("res://title/selection.tres")
var sel_empty = StyleBoxEmpty.new()


func _ready():
	move_selection(0, 0)


func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		move_selection(0, -1)
	if event.is_action_pressed("ui_right"):
		move_selection(1, 0)
	if event.is_action_pressed("ui_down"):
		move_selection(0, 1)
	if event.is_action_pressed("ui_left"):
		move_selection(-1, 0)
	if event.is_action_pressed("ui_accept"):
		run_selection()


func move_selection(ox, oy):
	get_current_selection()["label"].add_stylebox_override("normal", sel_empty)
	sel_y = int(clamp(sel_y + oy, 0, menu_layout.size()-1))
	sel_x = int(clamp(sel_x + ox, 0, menu_layout[sel_y].size()-1))
	get_current_selection()["label"].add_stylebox_override("normal", sel_style)


func run_selection():
	var signal_name = get_current_selection()["signal_name"]
	emit_signal(signal_name)
	queue_free()


func get_current_selection() -> Dictionary:
	return menu_layout[sel_y][sel_x]