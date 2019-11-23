import git
import prepare
import osx
import win
import steam
import utils


utils.main(stage='release', steps=[
    git.assert_repo_is_clean,

    prepare.prompt_build_description,
    prepare.params,
    prepare.create_build_id_dump,

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

    prepare.delete_build_id_dump,
    git.publish_tag,
])
