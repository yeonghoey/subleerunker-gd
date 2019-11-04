import functools
import pprint
import re
import subprocess
import sys
import textwrap


def main(stage, steps):
    ctx = {'stage': stage}
    try:
        for f in steps:
            f(ctx)
    finally:
        print_boxed('Summary')
        dump(ctx)


def run(cmd, *args, **kwargs):
    """Wraps subprocess.run.

    `cmd` can be both a string which contains the shell command,
    or a tuple, which contains a format string of the shell command
    and its kwargs,`(cmd_format, cmd_kwargs)`.

    The tuple form of `cmd` can be used for concealing 
    some sensitive information, because this only prints out `cmd_format`.

    Before printing out and actually running it,
    this reformats multiline string `cmd` or `cmd_format`,
    into a single escaped command, while keeping it easy to be read by human.

    Finally, this puts some defaults parameters which are commonly applicable
    across the builder scripts.
    """
    if isinstance(cmd, tuple):
        cmd_format, cmd_kwargs = cmd
    else:
        cmd_format, cmd_kwargs = cmd, {}

    cmd_format = cmd_format.strip()
    cmd_format = re.sub(r'\n\s*', ' \\\n  ', cmd_format)
    print(f'$ {cmd_format}')
    cmd_rendered = cmd_format.format(**cmd_kwargs)
    kwargs_with_default = dict(
        shell=True,
        check=True,
        capture_output=True,
        text=True,
        timeout=300,
    )
    kwargs_with_default.update(kwargs)
    try:
        return subprocess.run(cmd_rendered, *args, **kwargs_with_default)
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
        print(f'{m} {k:24} {v}')


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
