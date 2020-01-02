extends Control

const InGame := preload("res://stage/ingame.tscn")

onready var _preset := preload("res://preset/subleerunker.gd").new()
onready var _Stadium := find_node("Stadium")
onready var _Signals := find_node("Signals")


func _ready():
	_restart()


func _on_RestartButton_pressed():
	_restart()


func _restart():
	var ingame = InGame.instance()
	ingame.init(_preset)
	_connect_signals_to_log(ingame)
	_Stadium.present(ingame)


func _connect_signals_to_log(ingame: Node):
	var signals := ingame.get_signal_list()
	var scripts := []
	var script := ingame.get_script() as Script
	while script != null:
		scripts.append(script)
		script = script.get_base_script()
	for sig in signals:
		var name = sig["name"]
		for scr in scripts:
			if scr.has_script_signal(name):
				_connect_log(ingame, name, sig["args"].size())
				break


func _connect_log(ingame: Node, name: String, n_args: int):
	ingame.connect(name, self, "_log_signal%d" % n_args, [name])


func _log_signal0(name):
	_log("%s()" % name)


func _log_signal1(a, name):
	_log("%s(%s)" % [name, a])


func _log_signal2(a, b, name):
	_log("%s(%s, %s)" % [name, a, b])


func _log(s: String) -> void:
	_Signals.add_item(s)
	var vscroll = _Signals.get_v_scroll()
	vscroll.call_deferred("set_value", vscroll.max_value)