extends Label


func _ready():
	var palette = preload("res://palette/default/palette.tscn").instance()
	add_color_override("font_color", palette.pick("Current"))
	Signals.connect("scored", self, "on_scored")


func on_scored(score):
	text = String(score)