SHELL = /bin/bash

ifndef ASEPRITE
$(error Set ASEPRITE to your Aseprite CLI path.)
endif

ifndef GODOT
$(error Set GODOT to your Godot CLI path.)
endif

# Export groups of sprites into sprite sheets
# sprites/<name>/*.aseprite
# => SUBLEERUNKER/sprites/<name>/sheet.png
#    SUBLEERUNKER/sprites/<name>/data.json
SPRITES = $(wildcard sprites/*)
SPRITES_SHEET = $(SPRITES:sprites/%=SUBLEERUNKER/sprites/%/sheet.png)
SPRITES_DATA = $(SPRITES:sprites/%=SUBLEERUNKER/sprites/%/data.json)


.PHONY: sprites icon export release 

sprites: $(SPRITES_SHEET) $(SPRITES_DATA)
	$(MAKE) -C 'SUBLEERUNKER' unpack

SUBLEERUNKER/sprites/%/sheet.png SUBLEERUNKER/sprites/%/data.json: sprites/%/*.aseprite
	mkdir -p 'SUBLEERUNKER/sprites/$*'
	find 'SUBLEERUNKER/sprites/$*' -name '*.tres' -delete
	"${ASEPRITE}" \
	--batch \
	--sheet-pack \
	--sheet 'SUBLEERUNKER/sprites/$*/sheet.png' \
	--data 'SUBLEERUNKER/sprites/$*/data.json' \
	--filename-format '{title}_{tag}:{tagframe}' \
	sprites/$*/*.aseprite

icon: SUBLEERUNKER/icon.png misc/icon.ico

SUBLEERUNKER/icon.png: misc/icon.png
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