extends Reference

const FILE_PATH = "user://options.json"

var _options := {
	fullscreen = true,
	hidecursor = true,
	music = true,
	sound = true,
}


func load_last():
	var last: Dictionary = _read_last()
	for key in last:
		var value = last[key]
		set_option(key, value, false)


func _read_last() -> Dictionary:
	var f := File.new()
	if f.file_exists(FILE_PATH):
		f.open(FILE_PATH, File.READ)
		var content = f.get_as_text()
		f.close()
		return parse_json(content)
	else:
		return _options


func set_option(key, value, do_save=true) -> void:
	call("_set_%s" % key, value)
	_options[key] = value
	if do_save:
		_save()


func _save():
	var f := File.new()
	f.open(FILE_PATH, File.WRITE)
	f.store_string(to_json(_options))
	f.close()


func _set_hidecursor(b):
	var mouse_mode
	if b:
		mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.set_mouse_mode(mouse_mode)


func _set_fullscreen(b):
	OS.window_fullscreen = b


func _set_music(b):
	_mute_bus("Music", not b)


func _set_sound(b):
	_mute_bus("Sound", not b)


func _mute_bus(name: String, enable: bool):
	var bus_idx = AudioServer.get_bus_index(name)
	AudioServer.set_bus_mute(bus_idx, enable)


func get_option(key: String):
	return _options[key]