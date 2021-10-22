cc_library(
    name = "com_github_blake2_blake2",
    srcs = [
        "ref/blake2s-ref.c",
        "ref/blake2b-ref.c",
    ] + glob(["src/*.h"]),
    hdrs = [
        "ref/blake2.h",
        "ref/blake2-impl.h",
    ],
    includes = [
        "src",
    ],
    linkstatic = select({
        "@com_stripe_ruby_typer//tools/config:linkshared": 0,
        "//conditions:default": 1,
    }),
    visibility = ["//visibility:public"],
)
