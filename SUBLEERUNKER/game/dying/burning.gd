extends Dying


func _ready():
	$AnimatedSprite.connect("animation_finished", self, "finish")
	$AnimatedSprite.play("default")