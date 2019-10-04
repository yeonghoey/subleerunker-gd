from datetime import datetime
import os

from utils import step, dump


@step
def params(ctx):
    name = 'SUBLEERUNKER'
    cwd = os.getcwd()
    godot_project = f'{cwd}/{name}'
    godot_cmd = f'{cwd}/godot/Godot 3.1.1.Steam.app/Contents/MacOS/Godot'
    build_id = datetime.utcnow().strftime('%Y%m%d-%H%M%S')

    old = {k for k in ctx}
    ctx['name'] = name
    ctx['cwd'] = cwd
    ctx['godot_project'] = godot_project
    ctx['godot_cmd'] = godot_cmd
    ctx['build_id'] = build_id
    dump(ctx, old)
