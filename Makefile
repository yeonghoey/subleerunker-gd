SHELL = /bin/bash

ifndef ASEPRITE
$(error Set ASEPRITE to your Aseprite CLI path.)
endif

.PHONY: compile export

# Pack themes into sheets
THEMES = $(wildcard themes/*)
THEMES_PACKED_PNG = $(THEMES:%=godot/%/atlas.png)
THEMES_PACKED_JSON = $(THEMES:%=godot/%/atlas.json)

compile: export
	$(MAKE) -C 'godot' compile

export: $(THEMES_PACKED_PNG) $(THEMES_PACKED_JSON)

godot/%/atlas.png godot/%/atlas.json: %/*.aseprite
	mkdir -p 'godot/$*'
	"${ASEPRITE}" \
	--batch \
	--sheet-pack \
	--sheet 'godot/$*/atlas.png' \
	--data 'godot/$*/atlas.json' \
	--filename-format '{title}-{tag}-{tagframe}' \
	$*/*.aseprite