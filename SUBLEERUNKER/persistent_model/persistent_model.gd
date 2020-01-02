extends Reference
"""The base class for models to be persisted.

Subclasses should implement:
	`get_file_path()`, which returns 'user://' path
	`get_default()`, which returns a dict of (String, Varient) pairs for when the file doesn't exist
	`on_load(data)`, where to init. Resposible for calling `set(k, v)` to keep the data loaded.
"""

var _data := {}


func get_file_path() -> String:
	assert(false) # Not Implemented
	return ""


func get_default() -> Dictionary:
	assert(false) # Not Implemented
	return {}


func on_load(data: Dictionary) -> void:
	assert(false) # Not Implemented


func _init() -> void:
	var data := _load()
	on_load(data)


func _load() -> Dictionary:
	var f := File.new()
	var p := get_file_path()
	if f.file_exists(p):
		f.open(p, File.READ)
		var content = f.get_as_text()
		f.close()
		return parse_json(content)
	else:
		return get_default()


func get(key: String):
	return _data[key]


func set(key: String, value) -> void:
	_data[key] = value


func save() -> void:
	var p := get_file_path()
	var d := Directory.new()
	d.make_dir_recursive(p.get_base_dir())
	var f := File.new()
	f.open(p, File.WRITE)
	f.store_string(to_json(_data))
	f.close()