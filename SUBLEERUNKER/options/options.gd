extends "res://persistent_model/persistent_model.gd"


func filepath() -> String:
	return "user://options.json"


func onload() -> void:
	var d := dataref()
	for k in d:
		var v = d[k]
		call("set_%s" % k, v)


func _v1() -> Dictionary:
	return {
		fullscreen = true,
		hidecursor = true,
		music = true,
		sound = true,
	}


func set_fullscreen(b: bool) -> void:
	OS.window_fullscreen = b
	dataref()["fullscreen"] = b


func set_hidecursor(b: bool) -> void:
	var mouse_mode
	if b:
		mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.set_mouse_mode(mouse_mode)
	dataref()["hidecursor"] = b


func set_music(b: bool) -> void:
	_mute_bus("Music", not b)
	dataref()["music"] = b


func set_sound(b: bool) -> void:
	_mute_bus("Sound", not b)
	dataref()["sound"] = b


func _mute_bus(name: String, enable: bool) -> void:
	var bus_idx = AudioServer.get_bus_index(name)
	AudioServer.set_bus_mute(bus_idx, enable)