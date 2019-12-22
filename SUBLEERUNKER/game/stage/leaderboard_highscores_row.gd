extends HBoxContainer

const Util := preload("res://misc/util.gd")


func _ready():
	var idx = get_index()
	var rank = idx+1
	$Rank.text = Util.get_rank_name(rank)
	$Name.text = "-"
	$Score.text = "-"


func populate(record: Dictionary):
	assert record.has_all(["name", "steam_id", "rank", "score"])
	$Rank.text = _get_rank_name(record)
	$Name.text = _get_renderable_name(record)
	$Score.text = _get_score(record)


func _get_rank_name(record: Dictionary):
	return Util.get_rank_name(record["rank"])


func _get_renderable_name(record: Dictionary):
	var name = record["name"]
	var font = $Name.get_font("font")
	var renderable = name != ""
	for c in name:
		var size = font.get_string_size(c)
		renderable = renderable and size.x > 0

	if renderable:
		return name
	else:
		return "<%d>" % record["steam_id"]


func _get_score(record: Dictionary):
	return String(record["score"])