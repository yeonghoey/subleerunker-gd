extends "res://persistent_model/persistent_model.gd"


func get_file_path() -> String:
	return "user://options.json"


func get_default() -> Dictionary:
	return {
		fullscreen = true,
		hidecursor = true,
		music = true,
		sound = true,
	}


func on_load(data: Dictionary) -> void:
	for k in data:
		var v = data[k]
		call("set_%s" % k, v)


func set_fullscreen(b: bool) -> void:
	OS.window_fullscreen = b
	set("fullscreen", b)


func set_hidecursor(b: bool) -> void:
	var mouse_mode
	if b:
		mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.set_mouse_mode(mouse_mode)
	set("hidecursor", b)


func set_music(b: bool) -> void:
	_mute_bus("Music", not b)
	set("music", b)


func set_sound(b: bool) -> void:
	_mute_bus("Sound", not b)
	set("sound", b)


func _mute_bus(name: String, enable: bool) -> void:
	var bus_idx = AudioServer.get_bus_index(name)
	AudioServer.set_bus_mute(bus_idx, enable)