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
def set_icon(ctx):
    rcedit = ctx['rcedit']
    icon_ico = ctx['icon_ico']
    win_exe = ctx['win_exe']

    run(f"""
        wine64 '{rcedit}'
        '{win_exe}' 
        --set-icon '{icon_ico}'
    """)


@step
def add_steam_appid_txt(ctx):
    """Add steam_appid.txt for testing."""

    win_root = ctx['win_root']
    steam_appid = ctx['steam_appid']

    win_steam_appid_txt = f'{win_root}/steam_appid.txt'
    with open(win_steam_appid_txt, 'wt') as f:
        f.write(f'{steam_appid}')

    old = {k for k in ctx}
    ctx['win_steam_appid_txt'] = win_steam_appid_txt
    dump(ctx, old)
