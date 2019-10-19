extends HBoxContainer


func _ready():
	var idx = get_index()
	var rank = idx+1
	$Rank.text = _get_rank_name(rank)
	$Name.text = "-"
	$Score.text = "-"


func _get_rank_name(rank):
	match rank:
		1: return "1ST"
		2: return "2ND"
		3: return "3RD"
		_: return "%dTH" % rank


func populate_entry(entry):
	$Name.text = _get_renderable_name(entry)
	$Score.text = _get_score(entry)


func _get_renderable_name(entry):
	var name = entry["name"]
	var font = $Name.get_font("font")

	var renderable = name != ""
	for c in name:
		var size = font.get_string_size(c)
		renderable = renderable and size.x > 0
	if renderable:
		return name
	else:
		return "<%d>" % entry["steamID"]


func _get_score(entry):
	return String(entry["score"])