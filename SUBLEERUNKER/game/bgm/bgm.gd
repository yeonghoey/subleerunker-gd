extends AudioStreamPlayer


func _ready():
	_connect_signals()


func _connect_signals():
	Signals.connect("hit", self, "_on_hit")


func _on_hit(px, player):
	stop()