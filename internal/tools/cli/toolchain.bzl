load(":common.bzl", "get_bin_name", "os_list")

_os_to_compatibility = {
    "linux" : [
        "@bazel_tools//platforms:linux",
        "@bazel_tools//platforms:x86_64",
    ],
    "mac" : [
        "@bazel_tools//platforms:osx",
        "@bazel_tools//platforms:x86_64",
    ],
    "windows" : [
        "@bazel_tools//platforms:windows",
        "@bazel_tools//platforms:x86_64",
    ]
}

FnInfo = provider(
    doc = "Information about the Fn Framework CLI.",
    fields = ["bin"]
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
    compatibility = _os_to_compatibility.get(os)
    fn_toolchain(
        name = toolchain_name,
        bin = ":%s" % bin_name
    )
    native.toolchain(
        name = native_toolchain_name,
        toolchain = ":%s" % toolchain_name,
        toolchain_type = ":tool_chain_type",
        exec_compatible_with = compatibility,
        target_compatible_with = compatibility
    )

def setup_toolchains():
    """
    Macro te set up the toolchains for the different platforms
    """
    native.toolchain_type(name = "toolchain_type")

    for os in list(os_list):
      _add_toolchain(os)

def fn_register():
    """
    Registers the Fn toolchains.
    """
    path = "//internal/tools/cli:fn_cli_%s_toolchain"
    for os in list(os_list):
      native.register_toolchains(path % os)
