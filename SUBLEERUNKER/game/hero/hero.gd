extends Mover

class_name Hero
"""Hero is the base class for the player character.

Hero has 8 parameters:
	- width: of desired ingame size
	- height: of desired ingame size
	- head_path: NodePath to Area2D (for hit)
	- feet_path: NodePath to Area2D (for pedaled)
	- animation_player_path: NodePath to AnimationPlayer
		- The AnimationPlayer should contain animations named 'idle', 'left', right'
	For Mover implementation,
	- acceleration_amount: float
	- friction_amount: float
	- max_speed: float

Hero emits three signals:
	- action_changed
	- hit
	- pedaled
"""

enum {
	ACTION_REST, 
	ACTION_LEFT,
	ACTION_RIGHT,
}

# Ingame size
export(float) var width
export(float) var height

# These should be Area2D
export(NodePath) var head_path
export(NodePath) var feet_path

export(float) var acceleration_amount
export(float) var friction_amount
export(float) var max_speed

signal action_changed(prev_action, action)
signal hit()
signal pedaled()

var _action := ACTION_REST
# For handling when LR keys are pressed simultaneously
var _action_overridden := false

onready var _head: Area2D = get_node(head_path)
onready var _feet: Area2D = get_node(feet_path)


func init(initial_pos: Vector2):
	position = initial_pos


func handle_action_input(left, right):
	var prev_action := _action
	match [_action, _action_overridden, left, right]:
		[_, _, false, false]:
			_action = ACTION_REST
			_action_overridden = false
		[_, _, true, false]:
			_action = ACTION_LEFT
			_action_overridden = false
		[_, _, false, true]:
			_action = ACTION_RIGHT
			_action_overridden = false
		[ACTION_LEFT, false, true, true]:
			_action = ACTION_RIGHT
			_action_overridden = true
		[ACTION_RIGHT, false, true, true]:
			_action = ACTION_LEFT
			_action_overridden = true
	if prev_action != _action:
		emit_signal("action_changed", prev_action, _action)


func _ready():
	_head.connect("body_entered", self, "_on_head_body_entered")
	_feet.connect("area_entered", self, "_on_feet_area_entered")


func _on_head_body_entered(body):
	# TODO: assert(body is Drop)
	body.queue_free()
	emit_signal("hit")
	queue_free()


func _on_feet_area_entered(area):
	emit_signal("pedaled")


func _process(delta):
	match _action:
		ACTION_REST:
			_process_idle()
		ACTION_LEFT:
			_process_left()
		ACTION_RIGHT:
			_process_right()


func _process_idle():
	pass


func _process_left():
	pass


func _process_right():
	pass


func _physics_process(delta: float):
	move(delta)


# Implementatino of Mover virtual methods
func _acceleration() -> Vector2:
	match _action:
		ACTION_LEFT:
			return Vector2(-acceleration_amount, 0.0)
		ACTION_RIGHT:
			return Vector2(acceleration_amount, 0.0)
		_:
			return Vector2(0.0, 0.0)


func _friction_amount() -> float:
	match _action:
		ACTION_REST:
			return friction_amount
		_:
			return 0.0


func _max_speed() -> float:
	return max_speed