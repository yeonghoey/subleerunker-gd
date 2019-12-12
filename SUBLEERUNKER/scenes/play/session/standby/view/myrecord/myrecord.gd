extends VBoxContainer

const Util := preload("res://misc/util.gd")

onready var label_rank_prev: Label = find_node("RankPrev")
onready var label_rank_to: Label = find_node("RankTo")
onready var label_rank_new: Label = find_node("RankNew")
onready var label_score_prev: Label = find_node("ScorePrev")
onready var label_score_to: Label = find_node("ScoreTo")
onready var label_score_new: Label = find_node("ScoreNew")


func populate(myrecord: Dictionary, last_result: Dictionary):
	var rank_prev: int = last_result.get("rank_prev", 0)
	var rank_new: int = last_result.get("rank_new", myrecord["rank"])
	var score_prev: int = last_result.get("score_prev", 0)
	var score_new: int = last_result.get("score_new", myrecord["score"])

	if rank_prev == 0:
		rank_prev = rank_new
	if score_prev == 0:
		score_prev = score_new

	_populate_rank(rank_prev, rank_new)
	_populate_score(score_prev, score_new)


func _populate_rank(rank_prev: int, rank_new: int):
	if rank_prev == rank_new:
		label_rank_prev.text = ""
		label_rank_to.text = ""
		label_rank_new.text = Util.get_rank_name(rank_new)
	else:
		label_rank_prev.text = Util.get_rank_name(rank_prev)
		label_rank_to.text = ">"
		label_rank_new.text = Util.get_rank_name(rank_new)


func _populate_score(score_prev: int, score_new: int):
	if score_prev == score_new:
		label_score_prev.text = ""
		label_score_to.text = ""
		label_score_new.text = String(score_new)
	else:
		label_score_prev.text = String(score_prev)
		label_score_to.text = ">"
		label_score_new.text = String(score_new)