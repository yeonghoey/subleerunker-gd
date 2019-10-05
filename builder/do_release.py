import prepare
import osx
import win
import steam
import utils


utils.main([
    prepare.params,

    osx.params,
    osx.export_dmg,
    osx.notarize,
    osx.extract_app,

    win.params,
    win.export_exe,
    win.set_icon,
    win.copy_steam_dll,

    # NOTE: Finish osx build after doing windows build,
    # because notarization takes time.
    osx.wait_until_notarized,
    osx.staple,

    steam.params,
    steam.generate_app_vdf,
    steam.generate_depot_osx_vdf,
    steam.generate_depot_win_vdf,
    steam.deploy,
])
