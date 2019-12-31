extends Node

const Mode := preload("res://mode/mode.gd")

onready var mode := Mode.new()


func _ready():
	print(mode.compile())
