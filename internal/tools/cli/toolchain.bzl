load(":common.bzl", "get_bin_name", "os_list")

_toolchain_type = "toolchain_type"

FnInfo = provider(
    doc = "Information about the Fn Framework CLI.",
    fields = {
        "bin" : "The Fn Framework binary."
    }
)

def _fn_cli_toolchain(ctx):
  toolchain_info = platform_common.ToolchainInfo(
      fn_info = FnInfo(
          bin = ctx.attr.bin
      )
  )
  return [toolchain_info]

fn_toolchain = rule(
    implementation = _fn_cli_toolchain,
    attrs = {
        "bin" : attr.label(mandatory = True)
    }
)

def _add_toolchain(os):
    toolchain_name = "fn_cli_%s" % os
    native_toolchain_name = "fn_cli_%s_toolchain" % os
    bin_name = get_bin_name(os)
    compatibility = ["@bazel_tools//platforms:%s" % os]

    fn_toolchain(
        name = toolchain_name,
        bin = ":%s" % bin_name,
        visibility = ["//visibility:public"]
    )

    native.toolchain(
        name = native_toolchain_name,
        toolchain = ":%s" % toolchain_name,
        toolchain_type = ":%s" % _toolchain_type,
        target_compatible_with = compatibility
    )

def setup_toolchains():
    """
    Macro te set up the toolchains for the different platforms
    """
    native.toolchain_type(name = _toolchain_type)

    for os in os_list:
      _add_toolchain(os)

def fn_register():
    """
    Registers the Fn toolchains.
    """
    path = "//internal/tools/cli:fn_cli_%s_toolchain"

    for os in os_list:
      native.register_toolchains(path % os)
