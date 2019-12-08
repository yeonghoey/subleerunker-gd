extends GameView

signal selected(mode_name)
signal canceled()


func _ready():
	pass


func _input(event):
	emit_signal("selected", "subleerunker")
	queue_free()