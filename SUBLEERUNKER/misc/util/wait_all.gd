extends Reference

signal done()

var _waiting := 0


func _init(pairs: Array) -> void:
	"""Each element of the pairs Array should be an array of [object, signal].
	"""
	for a in pairs:
		_wait(a[0], a[1])
	_waiting = pairs.size()


func _wait(object: Object, signal_: String):
	yield(object, signal_)
	_waiting -= 1
	if _waiting == 0:
		emit_signal("done")