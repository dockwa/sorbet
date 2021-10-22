workspace(name = "com_stripe_ruby_typer")

load("//third_party:externals.bzl", "register_sorbet_dependencies")

register_sorbet_dependencies()

load("@com_grail_bazel_toolchain//toolchain:deps.bzl", "bazel_toolchain_dependencies")

bazel_toolchain_dependencies()

load("@com_grail_bazel_toolchain//toolchain:rules.bzl", "llvm_toolchain")

llvm_toolchain(
    name = "llvm_toolchain_12_0_0",
    absolute_paths = True,
    llvm_mirror_prefixes = [
        "https://sorbet-deps.s3-us-west-2.amazonaws.com/",
        "https://artifactory-content.stripe.build/artifactory/github-archives/llvm/llvm-project/releases/download/llvmorg-",
        "https://github.com/llvm/llvm-project/releases/download/llvmorg-",
    ],
    llvm_version = "12.0.0",
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

load("@rules_ragel//ragel:ragel.bzl", "ragel_register_toolchains")

ragel_register_toolchains()

load("@rules_m4//m4:m4.bzl", "m4_register_toolchains")

m4_register_toolchains()

load("@rules_bison//bison:bison.bzl", "bison_register_toolchains")

bison_register_toolchains(
    # Clang 12+ introduced this flag. All versions of Bison at time of writing
    # (up to 3.7.6) include code flagged by this warning.
    extra_copts = ["-Wno-implicit-const-int-float-conversion"],
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

load("//third_party/gems:rules.bzl", "gemfile_lock_deps")

gemfile_lock_deps(
    name = "gems",

    # TODO: figure out how to discover these labels during the loading phase,
    # rather that listing them out explicitly. `glob` doesn't work here, so
    # we'll need to do something special within the `gemfile_lock_deps`
    # repository rule.
    gemfile_locks = [
        "//gems/sorbet/test/snapshot:{}/src/Gemfile.lock".format(test)
        for test in [
            "partial/bad-hash",
            "partial/bad-t",
            "partial/create-config",
            "partial/explosive-object",
            "partial/fake-object",
            "partial/fake-rails",
            "partial/local_gem",
            "partial/non-utf-8-file",
            "partial/real_singleton_class",
            "partial/rspec-lots",
            "partial/stack_master",
            "partial/stupidedi",
            "partial/typed-ignore",
            "partial/webmock",
            "total/empty",
            "total/sorbet-runtime",
        ]
    ],
)

load("@rules_rust//rust:repositories.bzl", "rust_repositories")

rust_repositories(
    edition = "2018",
    version = "1.51.0",
)

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories")

node_repositories()

BAZEL_VERSION = "4.2.1"

BAZEL_VERSION_LINUX_X86_64_SHA = "1a4f3a3ce292307bceeb44f459883859c793436d564b95319aacb8af1f20557c"

BAZEL_VERSION_LINUX_ARM64_SHA = "0a849f99d59eab7058212a89b2a0d2b6a17f1ef7ba7fb7a42523a7171bb1c64f"

BAZEL_VERSION_DARWIN_X86_64_SHA = "74d93848f0c9d592e341e48341c53c87e3cb304a54a2a1ee9cff3df422f0b23c"
