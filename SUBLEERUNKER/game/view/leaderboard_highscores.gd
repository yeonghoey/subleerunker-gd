extends VBoxContainer

const NUM_ROWS = 10

onready var _ui_rows = $Rows


func _ready():
	assert _ui_rows.get_child_count() == NUM_ROWS


func populate(records: Array):
	while records.size() > NUM_ROWS:
		records.pop_back()
	for idx in range(records.size()):
		var record = records[idx]
		_ui_rows.get_child(idx).populate(record)