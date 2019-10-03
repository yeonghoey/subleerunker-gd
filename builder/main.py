
import init
import macos
import utils


# NAME =
# VOLUME = f'/Volumes/{NAME}'
# STEAM_CONTENT_ROOT = 'steam/content/macos'
# STEAM_CONTENT_APP = f'steam/content/macos/{NAME}.app'

STEPS = [
    init.default,
    init.build_id,
    utils.stop,
    macos.export,
    macos.notarize,
    macos.extract_app,
    macos.staple,
]

ctx = {}
for f in STEPS:
    f(ctx)
