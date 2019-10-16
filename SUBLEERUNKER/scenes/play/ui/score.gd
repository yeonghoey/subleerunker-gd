extends PanelContainer

onready var label = $Label


func _ready():
	Signals.connect("scored", self, "on_scored")


func on_scored(score):
	label.text = String(score)