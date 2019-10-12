extends Control

onready var menuitem_play = {
	label = find_node("MenuItemPlay"), 
	handler="on_play",
}
onready var menuitem_vs = {
	label = find_node("MenuItemVS"),
	handler = "on_vs",
}
onready var menuitem_achievements = {
	label = find_node("MenuItemAchievements"),
	handler = "on_achievements",
}
onready var menuitem_options = {
	label = find_node("MenuItemOptions"),
	handler = "on_options",
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
	var handler = get_current_selection()["handler"]
	call(handler)


func on_play():
	print("play")


func on_vs():
	print("vs")
	

func on_achievements():
	print("achievements")
	

func on_options():
	print("options")


func get_current_selection() -> Dictionary:
	return menu_layout[sel_y][sel_x]