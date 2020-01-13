extends Node

const Scorer := preload("res://scorer/scorer.gd")
const DropFalling := preload("res://dropfalling/dropfalling.gd")
const DropLanding := preload("res://droplanding/droplanding.gd")

export(PackedScene) var DropFalling_: PackedScene
export(Vector2) var size: Vector2

signal landed()


func init(scorer: Scorer, starting_pos: Vector2) -> void:
	"""This will be called when a Spanwer decided to create this.

	'boundary' represents the size of the game area and
	'hero' is the hero which the player controls.
	"""
	var dropfalling: DropFalling = DropFalling_.instance()
	dropfalling.position = starting_pos
	dropfalling.connect("tree_exiting", self, "_on_dropfalling_tree_exiting", [dropfalling, scorer])
	add_child(dropfalling)


func _on_dropfalling_tree_exiting(dropfalling: DropFalling, scorer: Scorer):
	# When the drop hit the hero.
	if dropfalling.landed:
		_on_dropfalling_landed(dropfalling, scorer)
	else:
		_on_dropfalling_hit()


func _on_dropfalling_landed(dropfalling: DropFalling, scorer: Scorer) -> void:
	scorer.score()
	var droplanding := dropfalling.make_droplanding()
	droplanding.connect("tree_exiting", self, "queue_free")
	add_child(droplanding)
	emit_signal("landed")


func _on_dropfalling_hit() -> void:
	queue_free()