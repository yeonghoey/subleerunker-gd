SHELL = /bin/bash

ifndef ASEPRITE
$(error Set ASEPRITE to your Aseprite CLI path.)
endif

ifndef GODOT
$(error Set GODOT to your Godot CLI path.)
endif

.PHONY: pack export build

# Compile groups of sprites into sprite packs
# sprites/<name>/*.aseprite
# => godot/sprite_packs/<name>/sheet.png
#    godot/sprite_packs/<name>/data.json
SPRITES = $(wildcard sprites/*)
SPRITE_PACKS_SHEET = $(SPRITES:sprites/%=godot/sprite_packs/%/sheet.png)
SPRITE_PACKS_DATA = $(SPRITES:sprites/%=godot/sprite_packs/%/data.json)

pack: export
	$(MAKE) -C 'godot' pack

export: $(SPRITE_PACKS_SHEET) $(SPRITE_PACKS_DATA)

godot/sprite_packs/%/sheet.png godot/sprite_packs/%/data.json: sprites/%/*.aseprite
	mkdir -p 'godot/sprite_packs/$*'
	"${ASEPRITE}" \
	--batch \
	--sheet-pack \
	--sheet 'godot/sprite_packs/$*/sheet.png' \
	--data 'godot/sprite_packs/$*/data.json' \
	--filename-format '{title}_{tag}:{tagframe}' \
	sprites/$*/*.aseprite

build: 
	mkdir -p "$(dir $@)"
	"${GODOT}" \
	--path "$(CURDIR)/godot" \
	--export "macOS" \
	--quiet \
	'$(CURDIR)/dist/macos/release.dmg'