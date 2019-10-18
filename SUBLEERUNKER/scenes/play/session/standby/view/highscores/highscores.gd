extends VBoxContainer

const packed_row = preload("row.tscn")

onready var rows = $Rows


func _ready():
	Signals.emit_signal("steamagent_highscores_request", "default")
	var entries = yield(Signals, "steamagent_highscores_response")
	_populate_entries(entries)


func _populate_entries(entries):
	var d = {}
	for e in entries:
		var rank = e["global_rank"]
		d[rank] = e

	for rank in range(1, 11):
		var row = packed_row.instance()
		var entry = d.get(rank, {"global_rank": rank, "name": "-", "score": "-"})
		row.populate_entry(entry)
		rows.add_child(row)