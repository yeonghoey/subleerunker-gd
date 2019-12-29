SHELL = /bin/bash

GODOT = godot/Godot.app/Contents/MacOS/Godot
PROJECT = SUBLEERUNKER

.PHONY: run release canary logicx icon

run:
	open 'godot/Godot.app'

release:
	python builder/do_release.py

canary:
	python builder/do_canary.py

icon: misc/icon.ico

misc/icon.ico: $(PROJECT)/icon.png
	magick convert '$<' -define icon:auto-resize=256,128,64,48,32,16 '$@'

logicx: 
	find . -name '*.logicx' -exec touch '{}/.gdignore' \;