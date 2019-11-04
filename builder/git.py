from utils import step, run


@step
def assert_repo_is_clean(ctx):
    stage = ctx['stage']
    ret = run('git status --porcelain')
    content = ret.stdout.strip()
    if content:
        raise RuntimeError('Repository shuld be clean on %s' % stage)
