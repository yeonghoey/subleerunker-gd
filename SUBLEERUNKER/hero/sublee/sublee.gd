extends "res://hero/hero.gd"

export(PackedScene) var RedDying: PackedScene
export(PackedScene) var BlueDying: PackedScene


func interpret_dyingmessage(dyingmessage: String) -> PackedScene:
	if dyingmessage == "blue":
		return BlueDying
	return RedDying