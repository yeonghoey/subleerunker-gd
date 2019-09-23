SHELL = /bin/bash

ifndef GODOT
$(error Set GODOT to your Godot CLI path.)
endif

.PHONY: pack render reimport

pack: reimport
	"${GODOT}" \
	--path "$(CURDIR)" \
	--script "cli/pack.gd" \
	--quiet

render: reimport
	"${GODOT}" \
	--path "$(CURDIR)" \
	--script "cli/render.gd" \
	--quiet

reimport:
	# To make sure Godot imports newly generated resources,
	# First we launch Godot editor and quit
	# so that it can import at its initialization timing.
	"${GODOT}" \
	--path "$(CURDIR)" \
	--editor \
	--quit \
	> /dev/null 2>&1