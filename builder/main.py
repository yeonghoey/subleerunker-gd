import prepare
import osx
import win
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
]

ctx = {}
try:
    for f in STEPS:
        f(ctx)
finally:
    utils.print_boxed('Summary')
    utils.dump(ctx)
