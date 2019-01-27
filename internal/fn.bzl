load("//internal/tools/cli:download.bzl", _fn_binaries = "fn_binaries")
load("//internal/tools/cli:toolchain.bzl", _fn_register = "fn_register")
load("//internal/rules:fn.bzl", _fn = "fn")

fn_binaries = _fn_binaries
fn_register = _fn_register

fn = _fn
