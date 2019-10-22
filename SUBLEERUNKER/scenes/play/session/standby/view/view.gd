extends Control


onready var view_highscores = find_node("HighScores")
onready var view_myrecord = find_node("MyRecord")


func update_highscores(entries):
	view_highscores.populate_entries(entries)


func update_myrecord(myrecord, last_result):
	view_myrecord.populate(myrecord, last_result)