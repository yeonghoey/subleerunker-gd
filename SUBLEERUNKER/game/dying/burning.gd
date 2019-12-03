extends Dying


func _ready():
	$AnimatedSprite.connect("animation_finished", self, "emit_signal", ["finished"])
	$AnimatedSprite.play("default")
