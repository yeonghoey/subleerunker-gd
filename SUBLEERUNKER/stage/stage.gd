extends Control
"""The base class of all in-game scenes, which are supposed to be
placed within Stadium.

View defines the base size of the game. Sub-scenes should inherit this
to make sure all of the view have the same size, which is 320x480.

When trying to free Stage, subclasses should call close() and Stadium
will handle the cleanup.
"""

signal closed()


func _input(event):
	"""Subclasses should implement _input for handling inputs.

	In general, using _unhandled_input is a better fit for handling game inputs.
	However, there was an issue propagating _unhandled_input events to nodes
	under a Viewport. while it was fixed, but not released to 3.1.x
	https://github.com/godotengine/godot/issues/31802
	For now, using _input would just be okay, because SUBLEERUNKER
	won't use any GUI inputs.
	"""
	pass


func close():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	emit_signal("closed")
