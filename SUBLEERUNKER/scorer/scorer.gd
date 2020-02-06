extends Reference

signal initialized(score, combo)
signal scored(score)
signal combo_hit(combo)
signal combo_missed(last_combo)

const FREEZED := -1
const SCORE_BASE := 0
const COMBO_BASE := 1

var _freezed := false
var _score: int
var _combo: int


func initialize() -> void:
	_score = SCORE_BASE
	_combo = COMBO_BASE
	emit_signal("initialized", _score, _combo)


func freeze() -> int:
	_freezed = true
	return _score


func score() -> int:
	if _freezed:
		return FREEZED
	_score += _combo
	emit_signal("scored", _score)
	return _score


func hit_combo() -> int:
	if _freezed:
		return FREEZED
	_combo += 1
	emit_signal("combo_hit", _combo)
	return _combo


func miss_combo() -> int:
	if _freezed:
		return FREEZED
	var last_combo := _combo
	_combo = COMBO_BASE
	emit_signal("combo_missed", last_combo)
	return last_combo
