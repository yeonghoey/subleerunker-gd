extends Node

var viewport: Viewport
var myrecord: Dictionary

var W
var H

var score := 0
var end_score := 0
var last_result := {}
var wait_score_upload := false

var alive := true
var flamespawn_flip = false
var flamespawn_threshold = 0.25

var combo_exists = false
const COMBO_COOLTIME_MIN := 0.75
const COMBO_COOLTIME_MAX := 1.5
var combo_cooltime := 0.0
var n_combo := 0

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
	# Init
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
	if wait_score_upload:
		return
	if game_objects.get_child_count() > 0:
		return
	Signals.emit_signal("ended", last_result)
	set_process(false)


func _physics_process(delta):
	if alive:
		_try_spawn_flame()
		_try_place_combo(delta)


func _init_player():
	player = preload("res://game/player/default/player.tscn").instance()
	player.position = Vector2(W/2, H-player.H/2)
	controller = preload("controller.gd").new(player)
	game_objects.add_child(player)
	add_child(controller)


func _connect_signals():
	Signals.connect("hit", self, "_on_hit")
	Signals.connect("landed", self, "_on_landed")
	Signals.connect("game_combo_succeeded", self, "_on_game_combo_succeeded")
	Signals.connect("game_combo_failed", self, "_on_game_combo_failed")


func _on_hit(player):
	end_score = score
	if end_score > myrecord["score"]:
		wait_score_upload = true
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
		score += n_combo
		Signals.emit_signal("scored", score)


func _try_score_upload():
	SteamAgent.upload_score("default", end_score, self, "_on_upload_score")


func _on_upload_score(result):
	if not result["success"]:
		var retry_score_upload = preload("retry_score_upload.tscn").instance()
		retry_score_upload.init(end_score)
		Signals.connect("retry_score_upload_succeeded", self, "_on_retry_score_upload_succeeded")
		viewport.add_child(retry_score_upload)
	else:
		_finalize_upload_score(result)


func _on_retry_score_upload_succeeded(result):
	_finalize_upload_score(result)


func _finalize_upload_score(result):
	assert result["success"]
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
	wait_score_upload = false


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


func _try_place_combo(delta):
	if combo_exists:
		return
	
	if combo_cooltime > 0:
		combo_cooltime = max(combo_cooltime - delta, 0)
		return

	var combo = preload("res://game/combo/default/combo.tscn").instance()
	var x = (W - combo.W*2) * randf() + combo.W
	combo.position = Vector2(x, H - combo.H)
	game_objects.add_child(combo)
	combo_exists = true


func _on_game_combo_succeeded(combo):
	n_combo += 1
	Signals.emit_signal("game_combo_updated", n_combo)

	var combo_effect = preload("res://game/combo_effect/default/combo_effect.tscn").instance()
	combo_effect.init(n_combo)
	combo_effect.position = combo.position
	game_objects.add_child(combo_effect)
	combo_cooltime = _next_combo_cooltime()
	combo_exists = false


func _on_game_combo_failed(combo):
	n_combo = 0
	Signals.emit_signal("game_combo_updated", n_combo)

	combo_cooltime = _next_combo_cooltime()
	combo_exists = false


func _next_combo_cooltime():
	var r = COMBO_COOLTIME_MAX - COMBO_COOLTIME_MIN
	return COMBO_COOLTIME_MIN + (r * randf())