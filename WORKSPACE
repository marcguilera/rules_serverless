workspace(name = "rules_serverless")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
# Install the hermetic copy Fn CLI binaries.
load("//internal:fn.bzl", "fn_binaries", "fn_register")
fn_binaries()
fn_register()
