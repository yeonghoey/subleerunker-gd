extends Reference

const MODES = [
	"sublee", "sunmee", "yeongho"
]

func compile() -> Array:
	var a := []
	for name in MODES:
		var spec: Dictionary = load("res://mode/%s/%s.gd" % [name, name]).SPEC
		a.append(spec)
	return a