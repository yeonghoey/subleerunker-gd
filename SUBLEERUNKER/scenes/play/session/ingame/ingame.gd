extends Node

var viewport: Viewport
var myrecord: Dictionary

var W
var H

var score := 0
var end_score := 0
var last_result := {}
var wait_upload := false

var alive := true
var flamespawn_flip = false
var flamespawn_threshold = 0.25

var game_objects: Node
var player: Node
var controller: Node


func _ready():
	W = viewport.size.x
	H = viewport.size.y

	viewport.add_child(preload("res://game/background/default/background.tscn").instance())
	viewport.add_child(preload("res://game/stage/stage.tscn").instance())
	
	game_objects = Node.new()
	viewport.add_child(game_objects)
	_init_player()
	_connect_signals()
	Signals.emit_signal("scored", score)


func _process(delta):
	"""Handles the end of the ingame session.
	
	This checks until all of the following conditions are met
	1) Player got hit
	2) All game objects disappeared natually. Specifically:
	  a) Dying animation finished
	  b) All the dropping flames are landed.
	3) When breaking the record, uploading highscore to Steam succeeds.
	  a) This may fail because Steam rate limits the Upload 10 times per 10 minutes.
	  b) If it fails, the game shows the caveat message and make the player wait.
	"""
	if alive:
		return
	if wait_upload:
		return
	if game_objects.get_child_count() > 0:
		return
	Signals.emit_signal("ended", last_result)
	set_process(false)


func _physics_process(delta):
	if alive:
		_try_spawn_flame()


func _init_player():
	player = preload("res://game/player/default/player.tscn").instance()
	player.position = Vector2(W/2, H-player.H/2)
	controller = preload("controller.gd").new(player)
	game_objects.add_child(player)
	add_child(controller)


func _connect_signals():
	Signals.connect("hit", self, "_on_hit")
	Signals.connect("landed", self, "_on_landed")


func _on_hit(player):
	end_score = score
	if end_score > myrecord["score"]:
		wait_upload = true
		_try_score_upload()

	$AudioBGM.stop()
	controller.queue_free()
	player.queue_free()
	alive = false
	var die := preload("res://game/player_die/default/player_die.tscn").instance()
	die.position = player.position
	game_objects.add_child(die)


func _on_landed(flame):
	var land := preload("res://game/flame_land/default/flame_land.tscn").instance()
	land.position = flame.position
	game_objects.add_child(land)
	if alive:
		score += 1
		Signals.emit_signal("scored", score)


func _try_score_upload():
	SteamAgent.upload_score("default", end_score, self, "_on_upload_score")


func _on_upload_score(result):
	if not result["success"]:
		# TODO: Show a message and wait/retry
		return
	last_result = {}
	# NOTE: Because we only try to upload the score when
	# breaking the record, this is always expected to be true
	if result["score_changed"]:
		last_result = {
			rank_prev = result["global_rank_previous"],
			rank_new = result["global_rank_new"],
			score_prev = myrecord["score"],
			score_new = end_score,
		}
	wait_upload = false


func _try_spawn_flame():
	flamespawn_flip = not flamespawn_flip
	if not flamespawn_flip:
		return

	if randf() < flamespawn_threshold:
		var flame = preload("res://game/flame/default/flame.tscn").instance()
		var x = (W - flame.W*2) * randf() + flame.W
		flame.position = Vector2(x, -flame.H)
		game_objects.add_child(flame)
	flamespawn_threshold *= 1.001;