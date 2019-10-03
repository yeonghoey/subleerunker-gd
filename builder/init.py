from datetime import datetime
import os

from utils import step


@step
def default(ctx):
    ctx['name'] = 'SUBLEERUNKER'
    ctx['cwd'] = os.getcwd()


@step
def build_id(ctx):
    now = datetime.utcnow()
    build_id = now.strftime('%Y%m%d-%H%M%S')
    ctx['build_id'] = build_id
