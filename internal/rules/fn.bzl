load(":common.bzl", "fn_toolchain", "get_fn_bin")

def _args(ctx):
    args = ctx.actions.args()
    args.add("build")
    if ctx.attr.verbose:
        args.add("-v")
    if not ctx.attr.cache:
        args.add("--no-cache")
    if ctx.attr.work_dir:
        args.add("-w")
        args.add(ctx.attr.work_dir)
    if not ctx.attr.bump:
        args.add("--no-bump")
    if ctx.attr.local:
        args.add("--local")
    vars = ctx.attr.build_args.items()
    for var in list(vars):
        args.add("--build-arg")
        args.add_joined(var[0], var[1], join_with = "")
    return args

def _fn(ctx):
    bin = get_fn_bin(ctx)
    args = _args(ctx)

    ctx.actions.run(
        executable = bin,
        arguments = args,
        mnemonic = "FnBuild",
        progress_message = "Building %{name}"
    )

fn = rule(
    doc = "A build target for a fn project.",
    attrs = {
        "app" : attr.string(
            doc = "Name of the app to deploy.",
            mandatory = True,
        ),
        "local" : attr.bool(
            doc = "Skips the pushing of the image to Docker Hub",
            default = False
        ),
        "verbose" : attr.bool(
            doc = "Verbose mode.",
            default = False
        ),
        "cache" : attr.bool(
            doc = "Use docker cache.",
            default = True
        ),
        "work_dir" : attr.label(
            doc = "The working directory to build a function.",
            default = None
        ),
        "build_args" : attr.string_dict(
            doc = "A dict containing the build-time variables.",
            default = {}
        ),
        "bump" : attr.bool(
            doc = "Bump the version.",
            default = True
        )
    },
    implementation = _fn,
    toolchains = [fn_toolchain]
)
