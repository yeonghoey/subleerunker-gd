extends "res://pedalhitting/pedalhitting.gd"

const WaitAll := preload("res://misc/util/wait_all.gd")

const AUDIO_BY_COMBO := [
	null,
	null,
	preload("xnum_c.wav"),
	preload("xnum_d.wav"),
	preload("xnum_e.wav"),
	preload("xnum_f.wav"),
	preload("xnum_g.wav"),
	preload("xnum_a.wav"),
	preload("xnum_b.wav"),
]

var _combo: int

onready var _Label: Label = $Label
onready var _AudioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer
onready var _AnimationPlayer: AnimationPlayer = $AnimationPlayer


func init(combo: int) -> void:
	_combo = combo


func _ready():
	_play_label()
	_play_audio()
	yield(WaitAll.new([
		[_AnimationPlayer, "animation_finished"],
		[_AudioStreamPlayer, "finished"]
	]), "done")
	queue_free()


func _play_label():
	_Label.text = "x%d" % _combo
	# Make it centered
	var offset_x = _Label.rect_size.x / 2
	transform = transform.translated(Vector2(-offset_x, 0))
	_AnimationPlayer.play("default")


func _play_audio():
	var x := _combo if _combo < AUDIO_BY_COMBO.size() else AUDIO_BY_COMBO.size()-1
	_AudioStreamPlayer.stream = AUDIO_BY_COMBO[x]
	_AudioStreamPlayer.play()
