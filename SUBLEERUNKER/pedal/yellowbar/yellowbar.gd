extends "res://pedal/pedal.gd"

var _succeeded := false

onready var _Sprite = $Sprite
onready var _Shape = $CollisionShape2D.shape


func _ready():
	connect("area_entered", self, "_on_area_entered")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")


func _on_area_entered(area):
	trigger()


func _on_animation_finished(name):
	disappear()


func _physics_process(delta):
	# NOTE: Sync the sprite size and the collision shape
	var x = _Sprite.get_rect().size.x * _Sprite.scale.x
	_Shape.extents.x = x/2