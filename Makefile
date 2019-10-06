SHELL = /bin/bash

PROJECT = SUBLEERUNKER

ifndef ASEPRITE
$(error Set ASEPRITE to your Aseprite CLI path.)
endif

ifndef GODOT
$(error Set GODOT to your Godot CLI path.)
endif

# Export groups of sprites into sprite sheets
# sprites/<name>/*.aseprite
# => $(PROJECT)/sprites/<name>/sheet.png
#    $(PROJECT)/sprites/<name>/data.json
SPRITES = $(wildcard sprites/*)
SPRITES_SHEET = $(SPRITES:sprites/%=$(PROJECT)/sprites/%/sheet.png)
SPRITES_DATA = $(SPRITES:sprites/%=$(PROJECT)/sprites/%/data.json)
SPRITES_UNPACKED = $(SPRITES:sprites/%=$(PROJECT)/sprites/%/unpacked)


.PHONY: sprites icon export release 

sprites: $(SPRITES_UNPACKED) $(SPRITES_SHEET) $(SPRITES_DATA)

$(PROJECT)/sprites/%/unpacked: $(PROJECT)/sprites/%/sheet.png $(PROJECT)/sprites/%/data.json
	# Unpack a sprite sheet into AtlasTextures
	"${GODOT}" \
	--path "$(CURDIR)/$(PROJECT)" \
	--script "cli/unpack.gd" \
	"--sheet=sprites/$*/sheet.png" \
	"--data=sprites/$*/data.json" \
	"--base=sprites/$*"
	# Mark as unpacked
	touch '$@'

$(PROJECT)/sprites/%/sheet.png $(PROJECT)/sprites/%/data.json: sprites/%/*.aseprite
	mkdir -p '$(PROJECT)/sprites/$*'
	find '$(PROJECT)/sprites/$*' -name '*.tres' -delete
	"${ASEPRITE}" \
	--batch \
	--sheet-pack \
	--sheet '$(PROJECT)/sprites/$*/sheet.png' \
	--data '$(PROJECT)/sprites/$*/data.json' \
	--filename-format '{title}_{tag}:{tagframe}' \
	sprites/$*/*.aseprite


icon: $(PROJECT)/icon.png misc/icon.ico

$(PROJECT)/icon.png: misc/icon.png
	cp '$<' '$@'

misc/icon.ico: misc/icon.png
	magick convert '$<' -define icon:auto-resize=256,128,64,48,32,16 '$@'

misc/icon.png: misc/icon.aseprite
	"${ASEPRITE}" \
	--batch \
	'$<' \
	--save-as '$@'

canary:
	python builder/do_canary.py

release:
	python builder/do_release.py