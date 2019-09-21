SHELL = /bin/bash

ifndef GODOT
$(error Set GODOT to your Godot CLI path.)
endif

.PHONY: compile

THEMES = $(wildcard themes/*)
THEMES_PACKED_TRES = $(THEMES:%=%/atlas.tres)

compile: $(THEMES_PACKED_TRES)

themes/%/atlas.tres: themes/%/atlas.png themes/%/atlas.json
	# To make sure Godot imports newly generated resources,
	# First we launch Godot editor and quit
	# so that it can import at its initialization timing.
	"${GODOT}" \
	--path "$(CURDIR)" \
	--editor \
	--quit \
	> /dev/null 2>&1
	# NOTE: Custom arguments are passed in a counterintuitive way
	# because Godot CLI only supports custom arguments
	# in the form of "--key=value"
	"${GODOT}" \
	--path "$(CURDIR)" \
	--script "_scripts/y_sprite_pack_compile.gd" \
	"--sheet=$(word 1, $^)" \
	"--data=$(word 2, $^)" \
	"--tres=$@"