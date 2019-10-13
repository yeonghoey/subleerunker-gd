extends Control

onready var item_list = find_node("ItemList")


func _ready():
	item_list.add_item("1st")
	item_list.add_item("2nd")
