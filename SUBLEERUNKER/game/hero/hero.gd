extends Mover

const FORCE := 3600.0

enum {
	ACTION_REST, 
	ACTION_LEFT,
	ACTION_RIGHT,
}

var _action := ACTION_REST
# For handling when LR keys are pressed simultaneously
var _action_overridden := false


func _ready():
	$Head.connect("body_entered", self, "_on_Head_body_entered")
	$Feet.connect("area_entered", self, "_on_Feet_area_entered")


func _process(delta):
	update_animation()


func update_action(left, right):
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
	match [prev_action, _action]:
		[ACTION_REST, ACTION_LEFT], [ACTION_REST, ACTION_RIGHT]:
			$AudioRun.play()
		[ACTION_LEFT, ACTION_REST], [ACTION_RIGHT, ACTION_REST]:
			$AudioRun.stop()


func update_animation():
	match _action:
		ACTION_REST:
			$AnimationPlayer.play("player_idle")
		ACTION_LEFT:
			$AnimationPlayer.play("player_run_left")
		ACTION_RIGHT:
			$AnimationPlayer.play("player_run_right")


func _physics_process(delta: float):
	move(delta)


func _acceleration() -> Vector2:
	match _action:
		ACTION_LEFT:
			return Vector2(-FORCE, 0.0)
		ACTION_RIGHT:
			return Vector2(FORCE, 0.0)
		_:
			return Vector2(0.0, 0.0)


func _friction() -> float:
	match _action:
		ACTION_REST:
			return FORCE
		_:
			return 0.0


func _max_velocity() -> float:
	return 300.0


func _on_Head_body_entered(body):
	Signals.emit_signal("hit", self)


func _on_Feet_area_entered(area):
	Signals.emit_signal("game_combo_succeeded", area)