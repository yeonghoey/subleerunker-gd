from utils import run, RunError, step


@step
def export(ctx):
    build_id = ctx['build_id']

    run(f"mkdir -p '{cwd}/bin/macos/{build_id}'")
    out = run(f"""
        'godot/Godot 3.1.1.Steam.app/Contents/MacOS/Godot'
            --path "{cwd}/{NAME}"
            --export "macOS"
            --quiet
            '{cwd}/bin/macos/{build_id}/{NAME}.dmg'
    """)


@step
def notarize(ctx):
    try:
        run(f"""
            xcrun altool
                --notarize-app
                --primary-bundle-id 'com.yeonghoey.subleerunker.dmg'
                --file '{DMG}'
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
    run(f"hdiutil attach '{DMG}'")
    run(f"rm -rf '{STEAM_CONTENT_ROOT}'")
    run(f"mkdir '{STEAM_CONTENT_ROOT}'")
    run(f"cp -a '{VOLUME}'/. '{STEAM_CONTENT_ROOT}/'")
    run(f"hdiutil detach '{VOLUME}'")


@step
def staple(ctx):
    run(f"xcrun stapler staple '{STEAM_CONTENT_APP}'")
