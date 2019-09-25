extends Label

func _ready():
	add_color_override("font_color", PaletteDeprecated.get("current"))
	Signals.connect("scored", self, "on_scored")

func on_scored(score):
	text = String(score)