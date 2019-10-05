from utils import run, RunError, step, excerpt, dump


@step
def params(ctx):
    name = ctx['name']
    build_root = ctx['build_root']

    osx_root = f'{build_root}/osx'
    osx_dmg = f'{osx_root}/{name}.dmg'
    osx_app = f'{osx_root}/{name}.app'

    old = {k for k in ctx}
    ctx['osx_root'] = osx_root
    ctx['osx_dmg'] = osx_dmg
    ctx['osx_app'] = osx_app
    dump(ctx, old)


@step
def export_dmg(ctx):
    godot_cmd = ctx['godot_cmd']
    godot_project = ctx['godot_project']
    osx_root = ctx['osx_root']
    osx_dmg = ctx['osx_dmg']

    run(f"mkdir -p '{osx_root}'")
    run(f"""
        '{godot_cmd}'
            --path '{godot_project}'
            --export 'osx'
            --quiet
            '{osx_dmg}'
    """)


@step
def notarize(ctx):
    osx_dmg = ctx['osx_dmg']

    ret = run(f"""
        xcrun altool
            --notarize-app
            --primary-bundle-id 'com.yeonghoey.subleerunker.dmg'
            --file '{osx_dmg}'
            --username 'yeonghoey@gmail.com'
            --password '@keychain:yeonghoey-notarization'
    """)
    osx_notarization_uuid = excerpt(
        r'RequestUUID = ([a-zA-Z0-9-]+)', ret.stdout)

    old = {k for k in ctx}
    ctx['osx_notarization_uuid'] = osx_notarization_uuid
    dump(ctx, old)


@step
def wait_until_notarized(ctx):
    osx_notarization_uuid = ctx['osx_notarization_uuid']

    t, step = 0, 30
    while not check_if_notarized(osx_notarization_uuid):
        if t > 600:
            raise RuntimeError('Notarization failed')
        run(f'sleep {step}')
        t += step


def check_if_notarized(uuid):
    try:
        ret = run(f"""
            xcrun altool 
                --notarization-info '{uuid}'
                --username 'yeonghoey@gmail.com'
                --password '@keychain:yeonghoey-notarization'
        """)
        print(excerpt(r'(Status: [^\n]+)', ret.stdout))
        return 'Status: success' in ret.stdout
    except RunError:
        return False


@step
def extract_app(ctx):
    osx_root = ctx['osx_root']
    osx_dmg = ctx['osx_dmg']

    ret = run(f"hdiutil attach '{osx_dmg}'")
    dev_name = excerpt(r'/dev/(\w+)\s+GUID_partition_scheme', ret.stdout)
    volume = excerpt(r'(/Volumes/[^\n]+)', ret.stdout)
    run(f"cp -a '{volume}'/. '{osx_root}/'")
    run(f"hdiutil detach '{dev_name}'")
    run(f"rm {osx_dmg}")


@step
def staple(ctx):
    osx_app = ctx['osx_app']

    run(f"xcrun stapler staple '{osx_app}'")


@step
def add_steam_appid_txt(ctx):
    """Add steam_appid.txt for testing."""

    osx_app = ctx['osx_app']
    steam_appid = ctx['steam_appid']

    osx_steam_appid_txt = f'{osx_app}/Contents/MacOS/steam_appid.txt'
    with open(osx_steam_appid_txt, 'wt') as f:
        f.write(f'{steam_appid}')

    old = {k for k in ctx}
    ctx['osx_steam_appid_txt'] = osx_steam_appid_txt
    dump(ctx, old)
