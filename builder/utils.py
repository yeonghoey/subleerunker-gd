import functools
import pprint
import re
import subprocess
import sys
import textwrap


def run(cmd, *args, **kwargs):
    """Wraps subprocess.run.

    Formats multiline string `cmd` into one single escaped command,
    while keeping it easy to be read by human.

    Put some defaults parameters which are commonly applicable
    across the scripts.
    """
    cmd = cmd.strip()
    cmd = re.sub(r'\n\s*', ' \\\n  ', cmd)
    print(f'$ {cmd}')
    kwargs_with_default = dict(
        shell=True,
        check=True,
        capture_output=True,
        text=True,
        timeout=300,
    )
    kwargs_with_default.update(kwargs)
    try:
        return subprocess.run(cmd, *args, **kwargs_with_default)
    except subprocess.CalledProcessError as err:
        raise RunError(*err.args, output=err.output, stderr=err.stderr)


class RunError(subprocess.CalledProcessError):
    """Decorates subprocess.CalledProcessError.

    Overrides __str__ to print all of the details by default.
    """

    def __str__(self):
        return '\n'.join([f'cmd={self.cmd}',
                          f'returncode={self.returncode}',
                          f'stdout={self.stdout}',
                          f'stderr={self.stderr}'])


def step(f):
    """Marks a function as a top-most step of the build process."""
    @functools.wraps(f)
    def g(ctx):
        print_boxed(f'Step > {f.__module__}.{f.__name__}')
        f(ctx)
        print('\n' * 2, end='')
    return g


def dump(ctx, old=None):
    if old is None:
        old = {k for k in ctx}
    for k, v in ctx.items():
        m = ' ' if k in old else '+'
        print(f'{m} {k:20}\t{v}')


def print_boxed(text):
    print(boxed(text))


def boxed(text):
    side = '-' * len(text)
    return (f"+-{side}-+\n" +
            f"| {text} |\n" +
            f"+-{side}-+"
            )


@step
def stop(ctx):
    """Stops the process.

    Intended to be used for testing.
    """
    raise SystemExit(1)


def excerpt(pattern, string):
    mo = re.search(pattern, string)
    return mo.group(1)
