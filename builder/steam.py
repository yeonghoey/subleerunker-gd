import textwrap
from os.path import relpath, dirname

from utils import step, run, dump


@step
def params(ctx):
    build_root = ctx['build_root']

    steam_appid = '1167150'
    steam_depotid_osx = '1167151'
    steam_depotid_win = '1167152'
    steam_app_vdf = f'{build_root}/app.vdf'
    steam_depot_osx_vdf = f'{build_root}/depot_osx.vdf'
    steam_depot_win_vdf = f'{build_root}/depot_win.vdf'

    old = {k for k in ctx}
    ctx['steam_appid'] = steam_appid
    ctx['steam_depotid_osx'] = steam_depotid_osx
    ctx['steam_depotid_win'] = steam_depotid_win
    ctx['steam_app_vdf'] = steam_app_vdf
    ctx['steam_depot_osx_vdf'] = steam_depot_osx_vdf
    ctx['steam_depot_win_vdf'] = steam_depot_win_vdf
    dump(ctx, old)


@step
def generate_app_vdf(ctx):
    build_id = ctx['build_id']
    build_description = ctx['build_description']
    steam_appid = ctx['steam_appid']
    steam_depotid_osx = ctx['steam_depotid_osx']
    steam_depotid_win = ctx['steam_depotid_win']

    steam_app_vdf = ctx['steam_app_vdf']
    steam_depot_osx_vdf = ctx['steam_depot_osx_vdf']
    steam_depot_win_vdf = ctx['steam_depot_win_vdf']

    depot_osx_vdf_rel = relpath(steam_depot_osx_vdf, dirname(steam_app_vdf))
    depot_win_vdf_rel = relpath(steam_depot_win_vdf, dirname(steam_app_vdf))

    content = textwrap.dedent(f'''\
        "appbuild"
        {{
            "appid"       "{steam_appid}"
            "desc"        "Build {build_id}: {build_description}"
            "buildoutput" "./output/"
            "setlive"     ""
            "preview"     "0"
            "local"       ""
            "depots"
            {{
                "{steam_depotid_osx}" "{depot_osx_vdf_rel}"
                "{steam_depotid_win}" "{depot_win_vdf_rel}"
            }}
        }}
    ''')
    with open(steam_app_vdf, 'wt') as f:
        f.write(content)
    print(content)


@step
def generate_depot_osx_vdf(ctx):
    steam_depotid_osx = ctx['steam_depotid_osx']
    steam_depot_osx_vdf = ctx['steam_depot_osx_vdf']

    content = textwrap.dedent(f'''\
        "DepotBuildConfig"
        {{
            "DepotID"     "{steam_depotid_osx}"
            "ContentRoot" "./osx/"
            "FileMapping"
            {{
                "LocalPath" "*"
                "DepotPath" "."
                "recursive" "1"
            }}
        }}
    ''')
    with open(steam_depot_osx_vdf, 'wt') as f:
        f.write(content)
    print(content)


@step
def generate_depot_win_vdf(ctx):
    steam_depotid_win = ctx['steam_depotid_win']
    steam_depot_win_vdf = ctx['steam_depot_win_vdf']

    content = textwrap.dedent(f'''\
        "DepotBuildConfig"
        {{
            "DepotID"     "{steam_depotid_win}"
            "ContentRoot" "./win/"
            "FileMapping"
            {{
                "LocalPath" "*"
                "DepotPath" "."
                "recursive" "1"
            }}
        }}
    ''')
    with open(steam_depot_win_vdf, 'wt') as f:
        f.write(content)
    print(content)
