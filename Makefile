SHELL = /bin/bash

ifndef ASEPRITE
$(error Set ASEPRITE to your Aseprite CLI path.)
endif

ifndef GODOT
$(error Set GODOT to your Godot CLI path.)
endif

.PHONY: pack export build

# Export groups of sprites into sprite sheets
# sprites/<name>/*.aseprite
# => godot/sprites/<name>/sheet.png
#    godot/sprites/<name>/data.json
SPRITES = $(wildcard sprites/*)
SPRITES_SHEET = $(SPRITES:sprites/%=godot/sprites/%/sheet.png)
SPRITES_DATA = $(SPRITES:sprites/%=godot/sprites/%/data.json)

pack: export
	$(MAKE) -C 'godot' pack

export: $(SPRITES_SHEET) $(SPRITES_DATA)

godot/sprites/%/sheet.png godot/sprites/%/data.json: sprites/%/*.aseprite
	mkdir -p 'godot/sprites/$*'
	"${ASEPRITE}" \
	--batch \
	--sheet-pack \
	--sheet 'godot/sprites/$*/sheet.png' \
	--data 'godot/sprites/$*/data.json' \
	--filename-format '{title}_{tag}:{tagframe00}' \
	sprites/$*/*.aseprite

build: 
	mkdir -p "$(dir $@)"
	"${GODOT}" \
	--path "$(CURDIR)/godot" \
	--export "macOS" \
	--quiet \
	'$(CURDIR)/dist/macos/release.dmg'