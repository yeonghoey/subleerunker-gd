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


func on_set_fullscreen(b):
	OS.window_fullscreen = b


func on_set_hidecursor(b):
	var mouse_mode
	if b:
		mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.set_mouse_mode(mouse_mode)


func on_set_music(b):
	_mute_bus("Music", not b)


func on_set_sound(b):
	_mute_bus("Sound", not b)


func _mute_bus(name: String, enable: bool):
	var bus_idx = AudioServer.get_bus_index(name)
	AudioServer.set_bus_mute(bus_idx, enable)