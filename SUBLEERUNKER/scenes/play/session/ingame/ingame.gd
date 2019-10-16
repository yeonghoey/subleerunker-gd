extends Control

onready var W = rect_size.x
onready var H = rect_size.y

var viewport: Viewport
var seed_secs := 0
var score := 0
var alive := true
var flamespawn_flip = false
var flamespawn_threshold = 0.25

var game_objects: Node
var player: Node
var controller: Node


func _ready():
	seed_secs = OS.get_system_time_secs()
	seed(seed_secs)
	game_objects = Node.new()
	var stage = preload("res://game/stage/stage.tscn").instance()
	viewport.add_child(stage)
	viewport.add_child(game_objects)

	init_player()
	connect_signals()
	Signals.emit_signal("scored", score)


func init_player():
	player = preload("res://game/player/default/player.tscn").instance()
	player.position = Vector2(W/2, H-player.H/2)
	controller = preload("controller.gd").new(player)
	game_objects.add_child(player)
	add_child(controller)


func connect_signals():
	Signals.connect("hit", self, "on_hit")
	Signals.connect("landed", self, "on_landed")


func on_hit(player):
	$AudioBGM.stop()
	controller.queue_free()
	player.queue_free()
	alive = false
	var die := preload("res://game/player_die/default/player_die.tscn").instance()
	die.position = player.position
	game_objects.add_child(die)


func on_landed(flame):
	var land := preload("res://game/flame_land/default/flame_land.tscn").instance()
	land.position = flame.position
	game_objects.add_child(land)
	if alive:
		score += 1
		Signals.emit_signal("scored", score)


func _process(delta):
	if !alive and game_objects.get_child_count() == 0:
		Signals.emit_signal("ended", score)


func _physics_process(delta):
	if alive:
		try_spawn_flame()


func try_spawn_flame():
	flamespawn_flip = not flamespawn_flip
	if not flamespawn_flip:
		return

	if randf() < flamespawn_threshold:
		var flame = preload("res://game/flame/default/flame.tscn").instance()
		var x = (W - flame.W*2) * randf() + flame.W
		flame.position = Vector2(x, -flame.H)
		game_objects.add_child(flame)
	flamespawn_threshold *= 1.001;