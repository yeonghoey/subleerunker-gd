import itertools
import sys

from utils import run, RunError, copy_contents


NAME = 'SUBLEERUNKER'
DMG = f'dist/macos/{NAME}.dmg'
VOLUME = f'/Volumes/{NAME}'
STEAM_CONTENT_ROOT = 'steam/content/macos'
STEAM_CONTENT_APP = f'steam/content/macos/{NAME}.app'


def main(startfrom):
    STEPS = [
        notarize,
        extract_app,
        staple,
    ]

    if startfrom is None:
        startfrom = STEPS[0].__name__

    steps = itertools.dropwhile(lambda f: f.__name__ != startfrom, STEPS)
    for f in steps:
        f()


def notarize():
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


def extract_app():
    run(f"hdiutil attach '{DMG}'")
    run(f"rm -rf '{STEAM_CONTENT_ROOT}'")
    run(f"mkdir '{STEAM_CONTENT_ROOT}'")
    run(f"cp -a '{VOLUME}'/. '{STEAM_CONTENT_ROOT}/'")
    run(f"hdiutil detach '{VOLUME}'")


def staple():
    run(f"xcrun stapler staple '{STEAM_CONTENT_APP}'")


if __name__ == '__main__':
    startfrom = (None if len(sys.argv) < 2 else sys.argv[1])
    main(startfrom)