extends "res://box/box.gd"


func filepath() -> String:
	return "user://statbox.json"


func _v1() -> Dictionary:
	return {
		"modes": {},
	}


func _v1_modestat() -> Dictionary:
	return {
		"best_score": 0,
		"last_score": 0,
	}


func _ref_modestat(modename: String) -> Dictionary:
	var ref_modes: Dictionary = ref()["modes"]
	if not ref_modes.has(modename):
		ref_modes[modename] = _v1_modestat().duplicate(true)
	return ref_modes[modename]


func export_modestat(modename: String) -> Dictionary:
	return _ref_modestat(modename).duplicate(true)


func update_final_score(modename: String, final_score: int) -> void:
	var ref_modestat := _ref_modestat(modename)
	ref_modestat["last_score"] = final_score
	if final_score > ref_modestat["best_score"]:
		ref_modestat["best_score"] = final_score