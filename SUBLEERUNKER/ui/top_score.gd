extends Label


func _ready():
	var palette = preload("res://palette/default/palette.tscn").instance()
	add_color_override("font_color", palette.pick("Top"))
	Signals.connect("top_changed", self, "_top_changed")


func _top_changed(name, score):
	text = "%s %d" % [name, score]