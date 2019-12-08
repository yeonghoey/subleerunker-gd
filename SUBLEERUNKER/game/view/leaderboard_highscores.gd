extends VBoxContainer

const NUM_ROWS = 10

onready var rows = $Rows


func _ready():
	assert rows.get_child_count() == NUM_ROWS


func populate_entries(entries):
	while entries.size() > NUM_ROWS:
		entries.pop_back()
	for idx in range(entries.size()):
		var entry = entries[idx]
		rows.get_child(idx).populate_entry(entry)