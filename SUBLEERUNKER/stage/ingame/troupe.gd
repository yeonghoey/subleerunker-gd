extends Node
"""The class acts as the parent node of all ingame objects.
"""

signal cleared()


func cast(node: Node) -> void:
	add_child(node)


func _ready():
	# NOTE: This gives Troupe at least a couple of frames
	# to add some child nodes.
	set_process(false)
	call_deferred("set_process", true)


func _process(delta):
	if get_child_count() == 0:
		emit_signal("cleared")
		set_process(false)
		queue_free()