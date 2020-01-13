extends "res://dropfalling/dropfalling.gd"

export(PackedScene) var DropLanding_: PackedScene


func _on_Area2D_area_entered(area):
	queue_free()


func make_droplanding() -> DropLanding:
	"""Subclasses are responsible for creating their DropLanding instances
	"""
	var droplanding: DropLanding = DropLanding_.instance()
	droplanding.position = position
	return droplanding