extends Node

var WIDTH = 320
var HEIGHT = 480


func _ready():
	randomize()
	create_player()


func _physics_process(delta):
	try_spawn_flame()


var player_scene = preload("res://player/player.tscn")

func create_player():
	var player = player_scene.instance()
	print(player.H)
	player.position = Vector2(WIDTH/2, HEIGHT-player.H/2)
	add_child(player)


var flame_scene = preload("res://flame/flame.tscn")
var flamespawn_flip = false
var flamespawn_threshold = 0.25

func try_spawn_flame():
	flamespawn_flip = not flamespawn_flip
	if not flamespawn_flip:
		return

	if randf() < flamespawn_threshold:
		var flame = flame_scene.instance()
		var x = (WIDTH - flame.W*2) * randf() + flame.W/2
		flame.position = Vector2(x, -flame.H)
		add_child(flame)
	flamespawn_threshold *= 1.001;