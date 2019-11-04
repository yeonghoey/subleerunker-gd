from datetime import datetime, timezone, timedelta
import os

from utils import step, run, dump


@step
def params(ctx):
    name = 'SUBLEERUNKER'
    build_id = issue_build_id()
    cwd = os.getcwd()
    godot_project = f'{cwd}/{name}'
    godot_cmd = f'{cwd}/godot-steamed/bin/GodotSteamed.app/Contents/MacOS/Godot'
    rcedit = f'{cwd}/misc/rcedit-x64.exe'
    icon_ico = f'{cwd}/misc/icon.ico'
    steam_dll = f'{cwd}/godot-steamed/bin/steam_api64.dll'
    steamcmd = f'{cwd}/steamcmd/steamcmd.sh'
    build_root = f'{cwd}/builds/{build_id}'
    run(f"mkdir -p '{build_root}'")

    old = {k for k in ctx}
    ctx['name'] = name
    ctx['build_id'] = build_id
    ctx['cwd'] = cwd
    ctx['godot_project'] = godot_project
    ctx['godot_cmd'] = godot_cmd
    ctx['rcedit'] = rcedit
    ctx['icon_ico'] = icon_ico
    ctx['steam_dll'] = steam_dll
    ctx['steamcmd'] = steamcmd
    ctx['build_root'] = build_root
    dump(ctx, old)


def issue_build_id():
    now = datetime.utcnow()
    return now.strftime('%Y%m%d-%H%M%S')


@step
def prompt_build_description(ctx):
    build_description = input('Build description: ')
    if '"' in build_description:
        raise ValueError(
            "Steamworks build script doesn't allow putting double quotes")
    ctx['build_description'] = build_description
