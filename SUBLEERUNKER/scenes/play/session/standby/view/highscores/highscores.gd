extends VBoxContainer

const packed_row = preload("row.tscn")

onready var rows = $Rows


func _ready():
	for rank in range(1, 11):
		var row = packed_row.instance()
		rows.add_child(row)

	Signals.connect("highscores_responded", self, "_populate_entries")
	Signals.emit_signal("highscores_requested", "default")


func _populate_entries(entries):
	var d = {}
	for e in entries:
		var rank = e["global_rank"]
		d[rank] = e

	for rank in range(1, 11):
		var idx = rank-1
		var entry = d.get(rank, {"global_rank": rank, "name": "-", "score": "-"})
		rows.get_child(idx).populate_entry(entry)