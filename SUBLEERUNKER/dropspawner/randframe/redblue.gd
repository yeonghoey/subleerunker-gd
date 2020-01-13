extends "randframe.gd"

export(PackedScene) var RedDrop: PackedScene
export(PackedScene) var BlueDrop: PackedScene

func packed_drop() -> PackedScene:
	if randf() < 0.5:
		return RedDrop
	else:
		return BlueDrop