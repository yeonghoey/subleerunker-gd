extends "res://persistent_model/persistent_model.gd"


func filepath() -> String:
	return "user://statbox.json"


func _v1() -> Dictionary:
	return {
		modes = {},
	}