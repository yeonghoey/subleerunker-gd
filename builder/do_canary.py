import prepare
import osx
import win
import steam
import utils


utils.main(stage='canary', steps=[
    prepare.params,
    prepare.create_build_id_dump,

    osx.params,
    osx.export_dmg,
    osx.extract_app,

    win.params,
    win.export_exe,
    win.set_icon,

    # Add steam_appid.txt for testing
    steam.params,
    osx.add_steam_appid_txt,
    win.add_steam_appid_txt,

    prepare.delete_build_id_dump
])
