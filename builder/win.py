from utils import run, step, dump


@step
def params(ctx):
    name = ctx['name']
    build_root = ctx['build_root']

    win_root = f'{build_root}/win'
    win_exe = f'{win_root}/{name}.exe'

    old = {k for k in ctx}
    ctx['win_root'] = win_root
    ctx['win_exe'] = win_exe
    dump(ctx, old)


@step
def export_exe(ctx):
    godot_cmd = ctx['godot_cmd']
    godot_project = ctx['godot_project']
    win_root = ctx['win_root']
    win_exe = ctx['win_exe']

    run(f"mkdir -p '{win_root}'")
    run(f"""
        '{godot_cmd}'
            --path '{godot_project}'
            --export 'win'
            --quiet
            '{win_exe}'
    """)


@step
def copy_steam_dll(ctx):
    win_root = ctx['win_root']
    steam_dll = ctx['steam_dll']
    run(f"cp '{steam_dll}' '{win_root}/'")
