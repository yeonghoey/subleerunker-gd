SHELL = /bin/bash

GODOT = godot-steamed/bin/GodotSteamed.app/Contents/MacOS/Godot
PROJECT = SUBLEERUNKER

ifndef ASEPRITE
$(error Set ASEPRITE to your Aseprite CLI path.)
endif

# Export groups of sprites into sprite sheets
# sprites/<name>/*.aseprite
# => $(PROJECT)/assets/textures/<name>/sheet.png
#    $(PROJECT)/assets/textures/<name>/data.json
SPRITES = $(wildcard sprites/*)
SPRITES_SHEET = $(SPRITES:sprites/%=$(PROJECT)/assets/textures/%/sheet.png)
SPRITES_DATA = $(SPRITES:sprites/%=$(PROJECT)/assets/textures/%/data.json)
SPRITES_UNPACKED = $(SPRITES:sprites/%=$(PROJECT)/assets/textures/%/unpacked)


.PHONY: pack unpack icon export release 

pack:  $(SPRITES_SHEET) $(SPRITES_DATA)

unpack: $(SPRITES_UNPACKED) pack

$(PROJECT)/%/unpacked: $(PROJECT)/%/sheet.png $(PROJECT)/%/sheet.png.import $(PROJECT)/%/data.json
	# Unpack a sprite sheet into AtlasTextures
	'$(GODOT)' \
	--path "$(CURDIR)/$(PROJECT)" \
	--script "cli/unpack.gd" \
	"--sheet=$*/sheet.png" \
	"--data=$*/data.json" \
	"--base=$*"
	# Mark as unpacked
	touch '$@'

$(PROJECT)/assets/textures/%/sheet.png $(PROJECT)/assets/textures/%/data.json: sprites/%/*.aseprite
	mkdir -p '$(PROJECT)/assets/textures/$*'
	find '$(PROJECT)/assets/textures/$*' -name '*.tres' -delete
	"${ASEPRITE}" \
	--batch \
	--sheet-pack \
	--sheet '$(PROJECT)/assets/textures/$*/sheet.png' \
	--data '$(PROJECT)/assets/textures/$*/data.json' \
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