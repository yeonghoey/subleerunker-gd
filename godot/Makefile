SHELL = /bin/bash

ifndef GODOT
$(error Set GODOT to your Godot CLI path.)
endif

.PHONY: compile

THEMES = $(wildcard themes/*)
THEMES_PACKED_TRES = $(THEMES:%=%/atlas.tres)

compile: $(THEMES_PACKED_TRES)

themes/%/atlas.tres: themes/%/atlas.png themes/%/atlas.json
	# NOTE: Custom arguments are passed in a counterintuitive way
	# because Godot CLI only supports custom arguments in a form of "--key=value"
	"${GODOT}" \
	--path "$(CURDIR)" \
	--script "_scripts/y_sprite_pack_compile.gd" \
	"--sheet=$(word 1, $^)" \
	"--data=$(word 2, $^)" \
	"--tres=$@"