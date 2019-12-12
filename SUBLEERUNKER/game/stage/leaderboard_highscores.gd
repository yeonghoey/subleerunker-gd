extends VBoxContainer

const NUM_ROWS = 10

onready var Rows = $Rows


func _ready():
	assert Rows.get_child_count() == NUM_ROWS


func populate(records: Array):
	while records.size() > NUM_ROWS:
		records.pop_back()

	for idx in range(records.size()):
		var record = records[idx]
		Rows.get_child(idx).populate(record)