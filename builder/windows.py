from utils import run, step, dump


@step
def params(ctx):
    name = ctx['name']
    build_root = ctx['build_root']

    windows_root = f'{build_root}/windows'
    windows_exe = f'{windows_root}/{name}.exe'

    old = {k for k in ctx}
    ctx['windows_root'] = windows_root
    ctx['windows_exe'] = windows_exe
    dump(ctx, old)


@step
def export_exe(ctx):
    godot_cmd = ctx['godot_cmd']
    godot_project = ctx['godot_project']
    windows_root = ctx['windows_root']
    windows_exe = ctx['windows_exe']

    run(f"mkdir -p '{windows_root}'")
    run(f"""
        '{godot_cmd}'
            --path '{godot_project}'
            --export 'windows'
            --quiet
            '{windows_exe}'
    """)


@step
def copy_steam_dll(ctx):
    windows_root = ctx['windows_root']
    steam_dll = ctx['steam_dll']
    run(f"cp '{steam_dll}' '{windows_root}/'")
