from datetime import datetime, timezone, timedelta
import os

from utils import step, run, dump


@step
def params(ctx):
    name = 'SUBLEERUNKER'
    build_id = issue_build_id()
    cwd = os.getcwd()
    godot_project = f'{cwd}/{name}'
    godot_cmd = f'{cwd}/godot/Godot 3.1.1 Steam 1.46.app/Contents/MacOS/Godot'
    steam_dll = f'{cwd}/godot/steam_api64.dll'
    steamcmd = f'{cwd}/steamcmd/steamcmd.sh'
    build_root = f'{cwd}/builds/{build_id}'
    run(f"mkdir -p '{build_root}'")

    old = {k for k in ctx}
    ctx['name'] = name
    ctx['build_id'] = build_id
    ctx['cwd'] = cwd
    ctx['godot_project'] = godot_project
    ctx['godot_cmd'] = godot_cmd
    ctx['steam_dll'] = steam_dll
    ctx['steamcmd'] = steamcmd
    ctx['build_root'] = build_root
    dump(ctx, old)


def issue_build_id():
    kst = timezone(timedelta(hours=9))
    now = datetime.now(kst)
    return now.strftime('%Y%m%d-%H%M%S')
