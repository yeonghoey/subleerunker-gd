class_name Util


static func get_rank_name(rank: int) -> String:
	if rank == 0:
		return "-" # Unranked
	match rank % 10:
		1: return "%dST" % rank
		2: return "%dND" % rank
		3: return "%dRD" % rank
		_: return "%dTH" % rank