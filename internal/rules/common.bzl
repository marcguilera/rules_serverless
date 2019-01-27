fn_toolchain = "//internal/tools/cli:toolchain_type"
def get_fn_bin(ctx):
  ctx.toolchains[fn_toolchain].fn_info.bin
