extends "randframe.gd"

export(PackedScene) var RedDrop: PackedScene
export(PackedScene) var GreenDrop: PackedScene
export(PackedScene) var BlueDrop: PackedScene

func packed_drop() -> PackedScene:
	if randf() < 0.333:
		return RedDrop
	if randf() < 0.666:
		return GreenDrop
	else:
		return BlueDrop
