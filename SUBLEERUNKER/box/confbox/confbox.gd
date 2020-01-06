extends "res://box/box.gd"


func filepath() -> String:
	return "user://confbox.json"


func onload() -> void:
	var data := ref()
	for k in data:
		var v = data[k]
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
	# NOTE: when flipping fullscreen, some global state actions
	# don't get released. Releases all of the actions manually.
	for action in InputMap.get_actions():
		Input.action_release(action)
	ref()["fullscreen"] = b


func set_hidecursor(b: bool) -> void:
	var mouse_mode
	if b:
		mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.set_mouse_mode(mouse_mode)
	ref()["hidecursor"] = b


func set_music(b: bool) -> void:
	_mute_bus("Music", not b)
	ref()["music"] = b


func set_sound(b: bool) -> void:
	_mute_bus("Sound", not b)
	ref()["sound"] = b


func _mute_bus(name: String, enable: bool) -> void:
	var bus_idx = AudioServer.get_bus_index(name)
	AudioServer.set_bus_mute(bus_idx, enable)