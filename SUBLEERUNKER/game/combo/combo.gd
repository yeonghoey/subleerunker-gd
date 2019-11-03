extends Area2D

const W = 32.0
const H = 8.0

onready var sprite = $Sprite
onready var shape = $CollisionShape2D.shape

var _succeeded = false


func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	Signals.connect("game_combo_succeeded", self, "_on_game_combo_succeeded")


func _physics_process(delta):
	var x = sprite.get_rect().size.x * sprite.scale.x
	shape.extents.x = x/2


func _on_animation_finished(name):
	if not _succeeded:
		Signals.emit_signal("game_combo_failed", self)
	queue_free()


func _on_game_combo_succeeded(combo):
	if combo != self:
		return
	_succeeded = true
	queue_free()