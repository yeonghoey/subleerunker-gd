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

var _is_gameover := false
var _alive := []
var _dead := []


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
	Signals.connect("landed", self, "_on_landed")


func _on_game_flame_spawned():
	_spawn_flame("p1")
	_spawn_flame("p2")


func _spawn_flame(px: String):
	var flame = _new_flame(px)
	var screen_width = rect_size.x
	var flame_width = flame.W
	var x = (screen_width - flame_width*2) * randf() + flame_width
	flame.position = Vector2(x, -flame.H)
	_gameobject_groups[px].add_child(flame)


func _new_flame(px: String):
	var flame = preload("res://game/flame/default/flame.tscn").instance()
	flame.init(px)
	return flame


func _on_hit(px, player):
	if _is_gameover:
		return
	# Defter setting is_gameover = true to the next frame
	# instead of setting it here so that we can decide draw
	# when both players got hit at the same frame
	_controllers[px].queue_free()
	_controllers.erase(px)
	_players[px].queue_free()
	_players.erase(px)
	var die := preload("res://game/player_die/default/player_die.tscn").instance()
	die.position = player.position
	_gameobject_groups[px].add_child(die)


func _on_landed(px, flame):
	var land := preload("res://game/flame_land/default/flame_land.tscn").instance()
	land.position = flame.position
	_gameobject_groups[px].add_child(land)


func _process(delta):
	if _players.size() == _viewports.size():
		return
	if not _is_gameover:
		_settle_game_result()
		_is_gameover = true
	
	# Wait until all of the dead player's gameobjects disappear
	for px in _dead:
		var gameobject_group = _gameobject_groups[px]
		if gameobject_group.get_child_count() > 0:
			return
	Signals.emit_signal("scene_vs_game_ended")
	set_process(false)
	_cleanup()


func _settle_game_result():
	for px in _viewports:
		if px in _players:
			_alive.append(px)
		else:
			_dead.append(px)
	
	for px in _alive:
		var player = _players[px]
		var gameobject_group = _gameobject_groups[px]
		var gameobjects = gameobject_group.get_children()
		for node in gameobjects:
			if node != player:
				node.queue_free()


func _cleanup():
	for px in _gameobject_groups:
		_gameobject_groups[px].queue_free()
	queue_free()