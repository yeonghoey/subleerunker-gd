extends "res://dropfalling/dropfalling.gd"


func _on_Area2D_area_entered(area):
	queue_free()


func make_droplanding() -> DropLanding:
	"""Subclasses are responsible for creating their DropLanding instances
	"""
	# TODO: Implement droplanding for shower
	var droplanding: DropLanding = preload("res://droplanding/flame/red.tscn").instance()
	droplanding.position = position
	return droplanding
