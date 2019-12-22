extends VBoxContainer

const Util := preload("res://misc/util.gd")


func populate(myrecord: Dictionary, myrecord_break: Dictionary):
	if myrecord_break.empty():
		_populate_rank(myrecord["rank"], myrecord["rank"])
		_populate_score(myrecord["score"], myrecord["score"])
	else:
		_populate_rank(myrecord_break["rank_new"], myrecord_break["rank_old"])
		_populate_score(myrecord_break["score_new"], myrecord_break["score_old"])
	visible = true


func _populate_rank(rank_new: int, rank_old: int):
	var a: Label = find_node("RankOld")
	var b: Label = find_node("RankTo")
	var c: Label = find_node("RankNew")

	if rank_new == rank_old:
		a.text = ""
		b.text = ""
		c.text = Util.get_rank_name(rank_new)
	else:
		a.text = Util.get_rank_name(rank_old)
		b.text = ">"
		c.text = Util.get_rank_name(rank_new)


func _populate_score(score_new: int, score_old: int):
	var a: Label = find_node("ScoreOld")
	var b: Label = find_node("ScoreTo")
	var c: Label = find_node("ScoreNew")

	if score_new == score_old:
		a.text = ""
		b.text = ""
		c.text = String(score_new)
	else:
		a.text = String(score_old)
		b.text = ">"
		c.text = String(score_new)