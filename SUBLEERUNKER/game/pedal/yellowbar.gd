extends "res://game/pedal/pedal.gd"

var _succeeded := false

onready var _sprite = $Sprite
onready var _shape = $CollisionShape2D.shape


func _ready():
	connect("area_entered", self, "_on_area_entered")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")


func _on_area_entered(area):
	trigger()


func _on_animation_finished(name):
	disappear()


func _physics_process(delta):
	# NOTE: Sync the sprite size and the collision shape
	var x = _sprite.get_rect().size.x * _sprite.scale.x
	_shape.extents.x = x/2