extends Control
"""Handles VS game play.

Most of elements are required for each player.
These elements will be managed in dictionaries, with keys of 'p1', 'p2',
and the variable name for the common use will be 'px'.
"""

# args
var _viewports: Dictionary

# internal
var _gameobject_groups := {}
var _players := {}
var _controllers := {}


func init(viewports: Dictionary):
	_viewports = viewports.duplicate()


func _ready():
	for px in _viewports:
		_add_background(px)
		_add_stage(px)
		_add_gameobject_group(px)
		_add_player(px)

	_add_flame_spanwer()
	# TODO: _add_combo_spawner
	_connect_signals()


func _add_background(px: String):
	_viewports[px].add_child(preload("res://game/background/default/background.tscn").instance())


func _add_stage(px: String):
	_viewports[px].add_child(preload("res://game/stage/stage.tscn").instance())


func _add_gameobject_group(px: String):
	var gameobject_group = Node.new()
	_viewports[px].add_child(gameobject_group)
	_gameobject_groups[px] = gameobject_group


func _add_player(px):

	var player = _new_player(px)
	var x = rect_size.x / 2
	var y = rect_size.y - (player.H / 2)
	player.position = Vector2(x, y)
	_gameobject_groups[px].add_child(player)
	_players[px] = player

	var controller = preload("controller.gd").new(player, px)
	add_child(controller)
	_controllers[px] = controller


func _new_player(px: String):
	var player = preload("res://game/player/default/player.tscn").instance()
	player.init(px)
	return player


func _add_flame_spanwer():
	var flame_spawner = preload("res://game/flame_spawner/flame_spawner.tscn").instance()
	add_child(flame_spawner)


func _connect_signals():
	Signals.connect("game_flame_spawned", self, "_on_game_flame_spawned")
	Signals.connect("hit", self, "_on_hit")


func _on_game_flame_spawned():
	_spawn_flame("p1")
	_spawn_flame("p2")


func _spawn_flame(px: String):
	var flame = _new_flame()
	var screen_width = rect_size.x
	var flame_width = flame.W
	var x = (screen_width - flame_width*2) * randf() + flame_width
	flame.position = Vector2(x, -flame.H)
	_gameobject_groups[px].add_child(flame)


func _new_flame():
	return preload("res://game/flame/default/flame.tscn").instance()


func _on_hit(px, player):
	_controllers[px].queue_free()
	_controllers.erase(px)
	_players[px].queue_free()
	_players.erase(px)
	var die := preload("res://game/player_die/default/player_die.tscn").instance()
	die.position = player.position
	_gameobject_groups[px].add_child(die)


#func _process(delta):
#	"""Handles the end of the ingame session.
#
#	This checks until all of the following conditions are met
#	1) Player got hit
#	2) All game objects disappeared natually. Specifically:
#	  a) Dying animation finished
#	  b) All the dropping flames are landed.
#	3) When breaking the record, uploading highscore to Steam succeeds.
#	  a) This may fail because Steam rate limits the Upload 10 times per 10 minutes.
#	  b) If it fails, the game shows the caveat message and make the player wait.
#	"""
#	if alive:
#		return
#	if wait_score_upload:
#		return
#	if game_objects.get_child_count() > 0:
#		return
#	Signals.emit_signal("ended", last_result)
#	set_process(false)



#func _connect_signals():
#	Signals.connect("hit", self, "_on_hit")
#	Signals.connect("landed", self, "_on_landed")
#	Signals.connect("game_combo_succeeded", self, "_on_game_combo_succeeded")
#	Signals.connect("game_combo_failed", self, "_on_game_combo_failed")
#
#
#func _on_hit(player):
#	end_score = score
#	if end_score > myrecord["score"]:
#		wait_score_upload = true
#		_try_score_upload()
#
#	$AudioBGM.stop()
#	controller.queue_free()
#	player.queue_free()
#	alive = false
#	var die := preload("res://game/player_die/default/player_die.tscn").instance()
#	die.position = player.position
#	game_objects.add_child(die)
#
#
#func _on_landed(flame):
#	var land := preload("res://game/flame_land/default/flame_land.tscn").instance()
#	land.position = flame.position
#	game_objects.add_child(land)
#	if alive:
#		score += n_combo
#		Signals.emit_signal("scored", score)