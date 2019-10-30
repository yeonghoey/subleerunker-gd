extends Node

const FILE_PATH = "user://options.json"

var _options := {
	fullscreen = true,
	hidecursor = true,
	music = true,
	sound = true,
}


func _ready():
	_connect_signals()
	_load()


func _connect_signals():
	Signals.connect("option_get_requested", self, "_on_option_get_requested")
	Signals.connect("option_set_requested", self, "_on_option_set_requested")


func _on_option_get_requested(key):
	Signals.emit_signal("option_%s_updated" % key, _options[key])


func _on_option_set_requested(key, value):
	_set_option(key, value, true)
	Signals.emit_signal("option_%s_updated" % key, _options[key])


func _load():
	var options = _last_options()
	for key in options:
		var value = options[key]
		_set_option(key, value, false)
	

func _last_options():
	var f := File.new()
	if f.file_exists(FILE_PATH):
		f.open(FILE_PATH, File.READ)
		var content = f.get_as_text()
		f.close()
		return parse_json(content)
	else:
		return _options


func _set_option(key, value, do_save=true):
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