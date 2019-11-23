extends Node

onready var build_id = _load_version()

func _load_version():
	if ResourceLoader.exists("res://build_id.gd"):
		return load("res://build_id.gd").VALUE
	else:
		return "develop"