extends Mover

const W := 24.0
const H := 16.0

var _px := "p1"


func init(px: String):
	_px = px


func _ready():
	$AnimatedSprite.play("default")


func _physics_process(delta: float):
	var collision := move(delta)
	if collision:
		if collision.collider.is_in_group("Floor"):
			Signals.emit_signal("landed", _px, self)
			queue_free()


func _acceleration():
	return Vector2(0, 360)


func _friction_amount():
	return 0.0


func _max_speed():
	return 600.0