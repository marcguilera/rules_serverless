_toolchain = "//internal/tools/cli:toolchain_type"

def _fn(ctx):
  print("HEY")
  bin = ctx.toolchains[_toolchain].fn_info.bin
  print(bin)

## TEST RULE
fn = rule(
    implementation = _fn,
    toolchains = [_toolchain]
)
