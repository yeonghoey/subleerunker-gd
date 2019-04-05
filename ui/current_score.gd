extends Label

func _ready():
	add_color_override("font_color", Palette.get("current"))
	Signals.connect("scored", self, "on_scored")

func on_scored(score):
	text = String(score)