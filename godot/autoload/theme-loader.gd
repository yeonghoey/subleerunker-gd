extends Node

const Theme = preload("res://themes/theme.gd")

var default
var atlas

func _ready():
	default = Theme.new("default")
	atlas = ykSpritePack.compose(
		"res://themes/default/atlas.png", 
		"res://themes/default/atlas.json")