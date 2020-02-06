extends PanelContainer
"""This class for containing in game views.
"""

const Stage := preload("res://stage/stage.gd")

var _layers := []

onready var _Viewport: Viewport = find_node("Viewport")


func present(stage: Stage):
	_clear()
	_add_stage(stage)


func _clear():
	for l in _layers:
		var s = l["stage"]
		if s.is_connected("closed", self, "_on_closed"):
			s.disconnect("closed", self, "_on_closed")
	_layers = []
	for c in _Viewport.get_children():
		c.queue_free()


func overlay(stage: Stage) -> void:
	_add_stage(stage)


func _add_stage(stage: Stage) -> void:
	var idx := _layers.size()
	_layers.append({
		"stage": stage,
		"closed": false,
	})
	stage.connect("closed", self, "_on_closed", [idx])
	_Viewport.add_child(stage)


func _on_closed(idx: int) -> void:
	_layers[idx]["closed"] = true
	var last := _layers.size() - 1
	if idx != last:
		return
	var i := last
	while i >= 0 and _layers[i]["closed"]:
		_layers[i]["stage"].queue_free()
		_layers.pop_back()
		i -= 1
