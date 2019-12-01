extends Mover

const W := 48.0
const H := 72.0
const FORCE := 3600.0

var _px := "p1"

enum {ACTION_IDLE, ACTION_LEFT, ACTION_RIGHT}

var action = ACTION_IDLE
var turning = false


func init(px: String):
	_px = px


func _enter_tree():
	# NOTE: Add controller for testing if ran by itself
	if get_parent() == get_node("/root"):
		var controller = load("res://scenes/play/session/ingame/controller.gd").new(self)
		add_child(controller)


func _ready():
	$Head.connect("body_entered", self, "_on_Head_body_entered")
	$Feet.connect("area_entered", self, "_on_Feet_area_entered")


func _process(delta):
	update_animation()


func update_action(left, right):
	var next_action
	match [action, turning, left, right]:
		[_, _, false, false]:
			next_action = ACTION_IDLE
			turning = false
		[_, _, true, false]:
			next_action = ACTION_LEFT
			turning = false
		[_, _, false, true]:
			next_action = ACTION_RIGHT
			turning = false
		[ACTION_LEFT, false, true, true]:
			next_action = ACTION_RIGHT
			turning = true
		[ACTION_RIGHT, false, true, true]:
			next_action = ACTION_LEFT
			turning = true
	match [action, next_action]:
		[ACTION_IDLE, ACTION_LEFT], [ACTION_IDLE, ACTION_RIGHT]:
			$AudioRun.play()
		[ACTION_LEFT, ACTION_IDLE], [ACTION_RIGHT, ACTION_IDLE]:
			$AudioRun.stop()
	action = next_action


func update_animation():
	match action:
		ACTION_IDLE:
			$AnimationPlayer.play("player_idle")
		ACTION_LEFT:
			$AnimationPlayer.play("player_run_left")
		ACTION_RIGHT:
			$AnimationPlayer.play("player_run_right")


func _physics_process(delta: float):
	move(delta)


func _acceleration() -> Vector2:
	match action:
		ACTION_LEFT:
			return Vector2(-FORCE, 0)
		ACTION_RIGHT:
			return Vector2(FORCE, 0)
		_:
			return Vector2(0, 0)


func _friction_amount() -> float:
	match action:
		ACTION_IDLE:
			return FORCE
		_:
			return 0.0


func _max_speed() -> float:
	return 300.0


func _on_Head_body_entered(body):
	Signals.emit_signal("hit", _px, self)


func _on_Feet_area_entered(area):
	Signals.emit_signal("game_combo_succeeded", area)