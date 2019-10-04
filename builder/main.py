import prepare
import osx
import utils


STEPS = [
    prepare.params,

    osx.params,
    osx.export,
    osx.notarize,
    osx.extract_app,
    osx.staple,
]

ctx = {}
try:
    for f in STEPS:
        f(ctx)
finally:
    utils.print_boxed('Summary')
    utils.dump(ctx)
