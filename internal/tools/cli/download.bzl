load(":common.bzl", "get_bin_name", "os_list", "default_version")

_url = "https://github.com/fnproject/cli/releases/download/{version}/{file}"
_os_to_file = {
    "linux" : "fn_linux",
    "mac" : "fn_mac",
    "windows" : "fn.exe",
}

def _fn_binary(os):
    name = get_bin_name(os)
    file = _os_to_file.get(os)
    url = _url.format(
        file = file,
        version = default_version
    )
    native.http_file(
        name = name,
        urls = [url],
        executable = True
    )

def fn_binaries():
    """
    Installs the hermetic binary for Fn.
    """
    for os in os_list:
        _fn_binary(os)
