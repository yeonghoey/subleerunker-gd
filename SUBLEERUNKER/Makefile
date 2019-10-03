SHELL = /bin/bash

ifndef GODOT
$(error Set GODOT to your Godot CLI path.)
endif

SPRITES = $(wildcard sprites/*)
SPRITES_SHEET = $(SPRITES:%=%/sheet.png)
SPRITES_DATA = $(SPRITES:%=%/data.json)
SPRITES_UNPACKED = $(SPRITES:%=%/unpacked)


.PHONY: unpack

unpack: $(SPRITES_UNPACKED)

sprites/%/unpacked: sprites/%/sheet.png sprites/%/data.json
	# Unpack a sprite sheet into AtlasTextures
	"${GODOT}" \
	--path "$(CURDIR)" \
	--script "cli/unpack.gd" \
	"--sheet=$(word 1, $^)" \
	"--data=$(word 2, $^)" \
	"--base=$(dir $@)"
	# Mark as unpacked
	touch '$@'