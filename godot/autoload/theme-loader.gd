extends Node

const Theme = preload("res://themes/theme.gd")

var default

func _ready():
	default = Theme.new("default")