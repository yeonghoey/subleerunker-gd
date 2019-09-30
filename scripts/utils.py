import functools
import sys

import pexpect


spawn = functools.partial(pexpect.spawn,
                          encoding='utf-8',
                          logfile=sys.stdout)


EOF = pexpect.EOF


def run(*args, **kwargs):
    p = spawn(*args, **kwargs)
    p.expect(EOF)
    p.wait()


def attach_dmg(dmg_path):
    p = spawn('hdiutil', ['attach', dmg_path])
    p.expect(r'(?P<dev>/dev/disk\w+)\s+'
             r'(?P<scheme>Apple_HFS)\s+'
             r'(?P<volume>/Volumes/.+)\r\n')
    assert p.match is not None
    attach_info = p.match.groupdict()
    p.expect(EOF)
    p.wait()
    return attach_info


def copy_contents(src, dst):
    src = src.rstrip('/')
    dst = dst.rstrip('/')
    # Delete 'dst'
    run(f"rm -rf '{dst}'")
    run(f"mkdir '{dst}'")
    run(f"cp -a '{src}'/. '{dst}/'")


def detach_dev(dev):
    run(f"hdiutil detach '{dev}'")
