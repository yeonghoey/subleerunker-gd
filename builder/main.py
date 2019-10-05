import prepare
import osx
import win
import steam
import utils


STEPS = [
    prepare.params,

    osx.params,
    osx.export_dmg,
    osx.notarize,
    osx.extract_app,
    osx.staple,

    win.params,
    win.export_exe,
    win.copy_steam_dll,

    steam.params,
    steam.generate_app_vdf,
    steam.generate_depot_osx_vdf,
    steam.generate_depot_win_vdf,
    steam.deploy,
]

ctx = {}
try:
    for f in STEPS:
        f(ctx)
finally:
    utils.print_boxed('Summary')
    utils.dump(ctx)
