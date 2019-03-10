extends Node

const WIDTH = 320
const HEIGHT = 480

func _ready():
	randomize()
	create_player()

func _physics_process(delta):
	try_spawn_flame()

var player_scene = preload("res://player/player.tscn")

func create_player():
	var player = player_scene.instance()
	player.position = Vector2(WIDTH/2, HEIGHT-player.H/2)
	player.connect("hit", self, "_on_hit", [player])
	add_child(player)

var die_scene = preload("res://player/player-die.tscn")

func _on_hit(player):
	var die = die_scene.instance()
	die.position = player.position
	add_child(die)

var flame_scene = preload("res://flame/flame.tscn")
var flamespawn_flip = false
var flamespawn_threshold = 0.25

func try_spawn_flame():
	flamespawn_flip = not flamespawn_flip
	if not flamespawn_flip:
		return

	if randf() < flamespawn_threshold:
		var flame = flame_scene.instance()
		var x = (WIDTH - flame.W*2) * randf() + flame.W
		flame.position = Vector2(x, -flame.H)
		flame.connect("landed", self, "_on_landed", [flame])
		add_child(flame)
	flamespawn_threshold *= 1.001;

var land_scene = preload("res://flame/flame-land.tscn")

func _on_landed(flame):
	var land = land_scene.instance()
	land.position = flame.position
	add_child(land)