import prepare
import macos
import utils


STEPS = [
    prepare.params,

    macos.params,
    macos.export,
    macos.notarize,
    macos.extract_app,
    macos.staple,
]

ctx = {}
try:
    for f in STEPS:
        f(ctx)
finally:
    utils.print_boxed('Summary')
    utils.dump(ctx)
