extends Control

var _current_mode: String = ""

onready var _frame: GameFrame = find_node("Frame")


func _ready():
	_display_modeselection()


func _display_modeselection():
	var modeselection = preload("res://game/view/modeselection.tscn").instance()
	modeselection.connect("selected", self, "_on_modeselection_selected")
	modeselection.connect("canceled", self, "_on_modeselection_canceled")	
	_frame.display(modeselection)


func _on_modeselection_selected(mode_name: String):
	_current_mode = mode_name


func _on_modeselection_canceled():
	pass


func _display_leaderboard():
	var leaderboard := preload("res://game/view/leaderboard.tscn").instance()
	var preset := GamePreset.of(_current_mode)
	leaderboard.init(preset)
	_frame.display(leaderboard)