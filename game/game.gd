extends Node

const W := 320.0
const H := 480.0

signal ended

var alive := true

func _ready():
	randomize()
	create_player()

func _process(delta):
	if !alive and $Objects.get_child_count() == 0:
		emit_signal("ended")
		queue_free()

func _physics_process(delta):
	if alive:
		try_spawn_flame()

func create_player():
	var player := preload("res://player/player.tscn").instance()
	player.position = Vector2(W/2, H-player.H/2)
	player.connect("hit", self, "_on_hit", [player])
	$Objects.add_child(player)

func _on_hit(player):
	alive = false
	var die := preload("res://player/player-die.tscn").instance()
	die.position = player.position
	$Objects.add_child(die)

var flamespawn_flip = false
var flamespawn_threshold = 0.25

func try_spawn_flame():
	flamespawn_flip = not flamespawn_flip
	if not flamespawn_flip:
		return

	if randf() < flamespawn_threshold:
		var flame := preload("res://flame/flame.tscn").instance()
		var x = (W - flame.W*2) * randf() + flame.W
		flame.position = Vector2(x, -flame.H)
		flame.connect("landed", self, "_on_landed", [flame])
		$Objects.add_child(flame)
	flamespawn_threshold *= 1.001;

func _on_landed(flame):
	var land := preload("res://flame/flame-land.tscn").instance()
	land.position = flame.position
	$Objects.add_child(land)