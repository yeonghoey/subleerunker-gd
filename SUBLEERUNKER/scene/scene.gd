extends Control
"""The base class of all top-level scenes.

Subclasses are responsible for calling 'close' so that the Main scene
can recognize that the scene is ready to remove from the SceneTree.
"""

signal closed()

var _closing := false
var _closed := false


func _enter_tree() -> void:
	set_process_input(true)
	set_process_unhandled_input(true)
	_closing = false
	_closed = false


func mark_closing() -> void:
	set_process_input(false)
	set_process_unhandled_input(false)
	_closing = true


func close() -> void:
	if not _closing:
		mark_closing()
	_closed = true
	emit_signal("closed")


func wait_closed():
	if _closed:
		yield(get_tree(), "idle_frame")
	else:
		yield(self, "closed")
