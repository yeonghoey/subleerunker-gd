from utils import step, run


@step
def assert_repo_is_clean(ctx):
    stage = ctx['stage']
    ret = run('git status --porcelain')
    content = ret.stdout.strip()
    if content:
        raise RuntimeError('Repository shuld be clean on %s' % stage)


@step
def publish_tag(ctx):
    build_id = ctx['build_id']
    build_description = ctx['build_description']
    run(f"git tag --annotate '{build_id}' -m '{build_description}'")
    run(f"git push origin '{build_id}'")
