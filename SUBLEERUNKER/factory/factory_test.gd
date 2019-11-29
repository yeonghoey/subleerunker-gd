extends Node


func _ready():
	var factory = Factory.of("subleerunker")
	add_child(factory.make("hero"))
	add_child(factory.make("drop"))
	add_child(factory.make("pedal"))