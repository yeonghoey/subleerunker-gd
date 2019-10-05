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

    try:
        run(f"""
            xcrun altool
                --notarize-app
                --primary-bundle-id 'com.yeonghoey.subleerunker.dmg'
                --file '{osx_dmg}'
                --username 'yeonghoey@gmail.com'
                --password '@keychain:yeonghoey-notarization'
        """)
        # NOTE: It's complicated to check if it's fully approved.
        # Just wait 30 seconds.
        run('sleep 30')
    except RunError as err:
        if 'The software asset has already been uploaded' not in err.stderr:
            raise


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
