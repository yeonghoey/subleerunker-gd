extends GameView

var _preset: GamePreset
var _myrecord_break: Dictionary

onready var _ui_highscores = find_node("HighScores")
onready var _ui_myrecord = find_node("MyRecord")
onready var _ui_presskey = find_node("PressKey")


func init(preset: GamePreset, myrecord_break: Dictionary):
	assert _myrecord_break.empty() or _myrecord_break.has_all(
			["rank_old", "rank_new", "score_old", "score_new"])
	_preset = preset
	_myrecord_break = myrecord_break


func _ready():
	_prepend_background()
	_ovrride_labelcolor()
	SteamAgent.fetch_myrecord("default", self, "_on_fetch_myrecord")


func _prepend_background():
	var background := _preset.make("background")
	add_child(background)
	move_child(background, 0)

	
func _ovrride_labelcolor():
	var labelcolor: Color = _preset.take("labelcolor")
	for label in get_tree().get_nodes_in_group("GameLabel"):
		label.add_color_override("font_color", labelcolor)


func _on_fetch_myrecord(entries):
	var myrecord := {rank=0, score=0}
	if entries != null and entries.size() == 1:
		var entry = entries[0]
		myrecord["rank"] = entry["global_rank"]
		myrecord["score"] = entry["score"]

	_ui_myrecord.populate(myrecord, _myrecord_break)
	SteamAgent.fetch_highscores("default", self, "_on_fetch_highscores")


func _on_fetch_highscores(entries):
	# Translate Steam callResult(entries) into records,
	# an Array of Dictionaries, each of which contains
	# "name", "steam_id", "rank", "score"
	var records := []
	for entry in entries:
		records.append({
			name = entry["name"],
			steam_id = entry["steamID"],
			rank = entry["global_rank"],
			score = entry["score"],
		})
	_ui_highscores.populate(records)