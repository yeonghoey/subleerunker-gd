class_name Utils


static func get_rank_name(rank: int) -> String:
	match rank:
		1: return "1ST"
		2: return "2ND"
		3: return "3RD"
		_: return "%dTH" % rank