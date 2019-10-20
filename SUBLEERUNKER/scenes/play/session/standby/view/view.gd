extends Control


onready var highscores = find_node("HighScores")
onready var myrecord = find_node("MyRecord")


func update_highscores(entries):
	highscores.populate_entries(entries)


func update_myrecord(myrecord, last_result):
	print(myrecord)
	pass