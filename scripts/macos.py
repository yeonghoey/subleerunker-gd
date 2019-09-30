from utils import attach_dmg, copy_contents, detach_dev

attach_info = attach_dmg('dist/macos/SUBLEERUNKER.dmg')
copy_contents(attach_info['volume'], 'steam/content/macs')
detach_dev(attach_info['dev'])
