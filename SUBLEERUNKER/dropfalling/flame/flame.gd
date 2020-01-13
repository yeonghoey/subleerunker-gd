extends "res://dropfalling/dropfalling.gd"


func _on_Area2D_area_entered(area):
	queue_free()