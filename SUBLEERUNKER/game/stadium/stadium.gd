extends PanelContainer
"""This class for containing in game views.
"""

const Stage := preload("res://game/stage/stage.gd")

var stages := []

onready var _viewport: Viewport = find_node("Viewport")


func present(stage: Stage):
	_clear()
	stages = []
	_add_stage(stage)


func _clear():
	for child in _viewport.get_children():
		child.queue_free()


func overlay(stage: Stage) -> void:
	_add_stage(stage)


func _add_stage(stage: Stage) -> void:
	var idx := stages.size()
	stages.append({
		"stage": stage,
		"closed": false,
	})
	stage.connect("closed", self, "_on_closed", [idx])
	_viewport.add_child(stage)


func _on_closed(idx: int) -> void:
	stages[idx]["closed"] = true
	var last := stages.size() - 1
	if idx != last:
		return
	var i := last
	while i >= 0 and stages[i]["closed"]:
		stages[i]["stage"].queue_free()
		stages.pop_back()
		i -= 1