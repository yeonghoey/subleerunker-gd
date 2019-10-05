import prepare
import osx
import windows
import utils


STEPS = [
    prepare.params,

    osx.params,
    osx.export_dmg,
    osx.notarize,
    osx.extract_app,
    osx.staple,

    windows.params,
    windows.export_exe,
    windows.copy_steam_dll,
]

ctx = {}
try:
    for f in STEPS:
        f(ctx)
finally:
    utils.print_boxed('Summary')
    utils.dump(ctx)
