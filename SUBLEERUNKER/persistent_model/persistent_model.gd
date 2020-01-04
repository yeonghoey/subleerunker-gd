extends Reference
"""The base class for models to be persisted.

Member functions of which names follow VERSION_FORMAT / MIGFUNC_FORMAT are reserved.
Versions start from 1 and get incremented by 1 for each change.

For example, let's say there was only v1 schema.
```
# `_v1` should return a Dictionary which contains the default values of the v1 schema.
func _v1() -> Dictionary:
	return {
		...
	}
```

When making some changes securely, both `_v2` and `_v1_to_v2` should be added:
```
func _v2() -> Dictionary:
	return {
		...
	}

func _v1_to_v2(d: Dictionary) -> Dictionary:
	return {
	}

var _v1 := ...
```

The constructor of this class make sure any data type get migrated to the latest version,
by running migration functions sequentially.

Any data in the model can be accessed through `dataref()`.

Subclasses should implement `filepath()`, which returns a user data path(user://)
Plus, they can implement `onload` to do custom initialization.

To make sure two same models don't overwrite each other,
any production instance should be created once, and which is generally done in `main.gd`.
"""

const VERSION_REGEX = "^_v(\\d+)$"
const VERSION_FORMAT = "_v%d"
const MIGFUNC_FORMAT = "_v%d_to_v%d"

var _body := {
	version = 0,
	data = {},
}


func filepath() -> String:
	assert(false) # Not Implemented
	return ""


func onload() -> void:
	pass


func _init() -> void:
	"""Loads body from path and migrate it to the latest version.
	"""
	var latest := _detect_latest()
	# Check validity
	assert(latest > 0)
	for v in range(1, latest):
		var migfunc := MIGFUNC_FORMAT % [v, v+1]
		assert(has_method(migfunc))
	_body = _load(latest)
	onload()


func _detect_latest() -> int:
	var regex := RegEx.new()
	regex.compile(VERSION_REGEX)
	var latest := 0
	for m in get_method_list():
		var ret := regex.search(m["name"])
		if ret:
			var v := int(ret.get_string(1))
			if v > latest:
				latest = v
	return latest


func _load(latest: int) -> Dictionary:
	var f := File.new()
	var p := filepath()
	if f.file_exists(p):
		f.open(p, File.READ)
		var content = f.get_as_text()
		f.close()
		var body: Dictionary = parse_json(content)
		return _migrate(body, latest)
	else:
		return _get_default(latest)


func _migrate(body: Dictionary, latest: int) -> Dictionary:
	# NOTE: body with no "version" means that it's legacy.
	# Just overwrite it with the latest version
	if not body.has("version"):
		return _get_default(latest)
	var v0: int = body["version"]
	var data: Dictionary = body["data"]
	for v in range(v0, latest):
		var migfunc := MIGFUNC_FORMAT % [v, v+1]
		data = call(migfunc, data)
	return {"version": latest, "data": data}


func _get_default(version: int) -> Dictionary:
	var default = call(VERSION_FORMAT % version)
	return {"version": version, "data": default.duplicate(true)}


func dataref() -> Dictionary:
	return _body["data"]


func save() -> void:
	var d := Directory.new()
	var p := filepath()
	d.make_dir_recursive(p.get_base_dir())
	var f := File.new()
	f.open(p, File.WRITE)
	f.store_string(to_json(_body))
	f.close()