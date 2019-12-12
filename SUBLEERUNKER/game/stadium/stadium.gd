extends PanelContainer
"""This class for containing in game views.
"""

const Stage := preload("res://game/stage/stage.gd")

onready var _viewport: Viewport = find_node("Viewport")


func present(stage: Stage):
	_clear_viewport()
	_viewport.add_child(stage)


func _clear_viewport():
	for child in _viewport.get_children():
		child.queue_free()