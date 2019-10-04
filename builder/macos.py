from utils import run, RunError, step, excerpt, dump


@step
def params(ctx):
    name = ctx['name']
    cwd = ctx['cwd']
    build_id = ctx['build_id']

    macos_root = f'{cwd}/builds/{build_id}/macos'
    macos_dmg = f'{macos_root}/{name}.dmg'
    macos_app = f'{macos_root}/{name}.app'

    old = {k for k in ctx}
    ctx['macos_root'] = macos_root
    ctx['macos_dmg'] = macos_dmg
    ctx['macos_app'] = macos_app
    dump(ctx, old)


@step
def export(ctx):
    godot_cmd = ctx['godot_cmd']
    godot_project = ctx['godot_project']
    macos_root = ctx['macos_root']
    macos_dmg = ctx['macos_dmg']

    run(f"mkdir -p '{macos_root}'")
    run(f"""
        '{godot_cmd}'
            --path '{godot_project}'
            --export 'macOS'
            --quiet
            '{macos_dmg}'
    """)


@step
def notarize(ctx):
    macos_dmg = ctx['macos_dmg']

    try:
        run(f"""
            xcrun altool
                --notarize-app
                --primary-bundle-id 'com.yeonghoey.subleerunker.dmg'
                --file '{macos_dmg}'
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
    macos_root = ctx['macos_root']
    macos_dmg = ctx['macos_dmg']

    ret = run(f"hdiutil attach '{macos_dmg}'")
    dev_name = excerpt(r'/dev/(\w+)\s+GUID_partition_scheme', ret.stdout)
    volume = excerpt(r'(/Volumes/[^\n]+)', ret.stdout)
    run(f"cp -a '{volume}'/. '{macos_root}/'")
    run(f"hdiutil detach '{dev_name}'")


@step
def staple(ctx):
    macos_app = ctx['macos_app']

    run(f"xcrun stapler staple '{macos_app}'")
