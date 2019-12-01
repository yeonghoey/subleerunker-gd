extends Mover

enum {
	ACTION_REST, 
	ACTION_LEFT,
	ACTION_RIGHT,
}

# These should be Area2D
export(NodePath) var head_path
export(NodePath) var feet_path

# AnimationPlayer should contain animations named "idle", "left", "right"
export(NodePath) var animation_player_path

export(float) var acceleration_size
export(float) var friction_amount
export(float) var max_speed

signal action_changed(prev_action, action)
signal hit()
signal pedaled()

var _action := ACTION_REST
# For handling when LR keys are pressed simultaneously
var _action_overridden := false

onready var _animation_player: AnimationPlayer = get_node(animation_player_path)


func process_input(left, right):
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
	get_node(head_path).connect("body_entered", self, "_on_head_body_entered")
	get_node(feet_path).connect("area_entered", self, "_on_feet_area_entered")


func _on_head_body_entered(body):
	emit_signal("hit")


func _on_feet_area_entered(area):
	emit_signal("pedaled")


func _process(delta):
	update_animation()


func update_animation():
	match _action:
		ACTION_REST:
			_animation_player.play("idle")
		ACTION_LEFT:
			_animation_player.play("left")
		ACTION_RIGHT:
			_animation_player.play("right")


func _physics_process(delta: float):
	move(delta)


# Implementatino of Mover virtual methods
func _acceleration() -> Vector2:
	match _action:
		ACTION_LEFT:
			return Vector2(-acceleration_size, 0.0)
		ACTION_RIGHT:
			return Vector2(acceleration_size, 0.0)
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