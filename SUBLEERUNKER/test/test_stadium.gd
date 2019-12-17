extends Control

const DummyStage := preload("res://test/dummy_stage.gd")

onready var _Stadium := find_node("Stadium")
onready var _stage1 := DummyStage.new(123)
onready var _stage2 := DummyStage.new(456)


func _ready():
	_Stadium.present(_stage1)
	_Stadium.overlay(_stage2)
	

func _on_Button1_pressed():
	_stage1.close()


func _on_Button2_pressed():
	_stage2.close()