extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	play()
	connect("animation_finished", self, "_on_finished")

func _on_finished():
	queue_free()