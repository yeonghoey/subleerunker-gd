extends AnimatedSprite

func _ready():
	play()
	connect("animation_finished", self, "_on_finished")

func _on_finished():
	queue_free()