extends Node

const Hero := preload("res://hero/hero.gd")
const DropFalling := preload("res://dropfalling/dropfalling.gd")
const DropLanding := preload("res://droplanding/droplanding.gd")

export(PackedScene) var DropFalling_: PackedScene
export(PackedScene) var DropLanding_: PackedScene

signal landed()


func init(boundary: Vector2, hero: Hero, hint = null) -> void:
	"""This will be called when a Spanwer decided to create this.

	'boundary' represents the size of the game area and
	'hero' is the hero which the player controls.
	'hint' will be an arbitrary parameter of the hint.
	"""
	var dropfalling: DropFalling = DropFalling_.instance()
	dropfalling.init(boundary, hero, hint)
	dropfalling.connect("tree_exiting", self, "_on_dropfalling_tree_exiting", [dropfalling])
	add_child(dropfalling)


func _on_dropfalling_tree_exiting(dropfalling: DropFalling):
	# When the drop hit the hero.
	if dropfalling.landed:
		_on_dropfalling_landed(dropfalling)
	else:
		_on_dropfalling_hit()


func _on_dropfalling_landed(dropfalling: DropFalling) -> void:
	var droplanding: DropLanding = DropLanding_.instance()
	droplanding.init(dropfalling)
	droplanding.connect("tree_exiting", self, "queue_free")
	add_child(droplanding)
	emit_signal("landed")


func _on_dropfalling_hit() -> void:
	queue_free()