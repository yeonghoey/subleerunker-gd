SHELL = /bin/bash

ifndef GODOT
$(error Set GODOT to your Godot CLI path.)
endif

.PHONY: pack

SPRITE_PACKS = $(wildcard sprite_packs/*)
SPRITE_PACKS_PACK = $(SPRITE_PACKS:%=%/pack.tres)

pack: $(SPRITE_PACKS_PACK)

sprite_packs/%/pack.tres: sprite_packs/%/sheet.png sprite_packs/%/data.json
	# To make sure Godot imports newly generated resources,
	# First we launch Godot editor and quit
	# so that it can import at its initialization timing.
	"${GODOT}" \
	--path "$(CURDIR)" \
	--editor \
	--quiet \
	--quit \

	# NOTE: Custom arguments are passed in a counterintuitive way
	# because Godot CLI only supports custom arguments
	# in the form of "--key=value"
	"${GODOT}" \
	--path "$(CURDIR)" \
	--script "cli/compile_sprite_pack.gd" \
	--quiet \
	"--sheet=$(word 1, $^)" \
	"--data=$(word 2, $^)" \
	"--pack=$@"