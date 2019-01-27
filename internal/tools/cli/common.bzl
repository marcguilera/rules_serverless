default_version = "0.5.44"
os_list = [
    "linux",
    "mac",
    "windows"
]

def get_bin_name(os):
    return "fn_cli_%s_bin" % os
