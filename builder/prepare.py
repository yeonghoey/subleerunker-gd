from datetime import datetime
import os

from utils import step, dump


@step
def params(ctx):
    name = 'SUBLEERUNKER'
    build_id = datetime.utcnow().strftime('%Y%m%d-%H%M%S')
    cwd = os.getcwd()
    godot_project = f'{cwd}/{name}'
    godot_cmd = f'{cwd}/godot/Godot 3.1.1 Steam 1.46.app/Contents/MacOS/Godot'

    old = {k for k in ctx}
    ctx['name'] = name
    ctx['build_id'] = build_id
    ctx['cwd'] = cwd
    ctx['godot_project'] = godot_project
    ctx['godot_cmd'] = godot_cmd
    dump(ctx, old)
