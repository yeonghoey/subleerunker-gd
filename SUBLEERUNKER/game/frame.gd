extends PanelContainer

class_name GameFrame
"""GameFrame is the class for containing in game views.
"""

onready var _viewport: Viewport = find_node("Viewport")


func display(view: GameView):
	_clear_viewport()
	_viewport.add_child(view)


func _clear_viewport():
	for child in _viewport.get_children():
		child.queue_free()