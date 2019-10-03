import functools
import re
import subprocess
import sys
import textwrap


def run(cmd, *args, **kwargs):
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
        print(err.args)
        raise RunError(*err.args, output=err.output, stderr=err.stderr)


class RunError(subprocess.CalledProcessError):
    def __str__(self):
        return '\n'.join([f'cmd={self.cmd}',
                          f'returncode={self.returncode}',
                          f'stdout={self.stdout}',
                          f'stderr={self.stderr}'])


def copy_contents(src, dst):
    src = src.rstrip('/')
    dst = dst.rstrip('/')
    # Delete 'dst'
    run(f"rm -rf '{dst}'")
    run(f"mkdir '{dst}'")
    run(f"cp -a '{src}'/. '{dst}/'")
