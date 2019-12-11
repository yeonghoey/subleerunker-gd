extends VBoxContainer


func populate(myrecord: Dictionary, myrecord_break: Dictionary):
	if myrecord_break.empty():
		_populate_rank(myrecord.rank, myrecord.rank)
		_populate_score(myrecord.score, myrecord.score)
	else:
		_populate_rank(myrecord_break.rank_old, myrecord_break.rank_new)
		_populate_score(myrecord_break.score_old, myrecord_break.score_new)
	visible = true


func _populate_rank(rank_old: int, rank_new: int):
	var a: Label = find_node("RankOld")
	var b: Label = find_node("RankTo")
	var c: Label = find_node("RankNew")

	if rank_old == rank_new:
		a.text = ""
		b.text = ""
		c.text = Util.get_rank_name(rank_new)
	else:
		a.text = Util.get_rank_name(rank_old)
		b.text = ">"
		c.text = Util.get_rank_name(rank_new)


func _populate_score(score_old: int, score_new: int):
	var a: Label = find_node("ScoreOld")
	var b: Label = find_node("ScoreTo")
	var c: Label = find_node("ScoreNew")

	if score_old == score_new:
		a.text = ""
		b.text = ""
		c.text = String(score_new)
	else:
		a.text = String(score_old)
		b.text = ">"
		c.text = String(score_new)