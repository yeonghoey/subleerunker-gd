SHELL = /bin/bash

ifndef ASEPRITE
$(error Set ASEPRITE to your Aseprite CLI path.)
endif

.PHONY: compile export

# Compile groups of sprites into sprite packs
# sprites/<name>/*.aseprite
# => godot/sprite_packs/<name>/sheet.png
#    godot/sprite_packs/<name>/data.json
SPRITES = $(wildcard sprites/*)
SPRITE_PACKS_SHEET = $(SPRITES:sprites/%=godot/sprite_packs/%/sheet.png)
SPRITE_PACKS_DATA = $(SPRITES:sprites/%=godot/sprite_packs/%/data.json)

compile: export
	$(MAKE) -C 'godot' compile

export: $(SPRITE_PACKS_SHEET) $(SPRITE_PACKS_DATA)

godot/sprite_packs/%/sheet.png godot/sprite_packs/%/data.json: sprites/%/*.aseprite
	mkdir -p 'godot/sprite_packs'
	"${ASEPRITE}" \
	--batch \
	--sheet-pack \
	--sheet 'godot/sprite_packs/$*/sheet.png' \
	--data 'godot/sprite_packs/$*/data.json' \
	--filename-format '{title}_{tag}:{tagframe}' \
	sprites/$*/*.aseprite