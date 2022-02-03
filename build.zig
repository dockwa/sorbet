const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    // thanks
    // https://github.com/kubkon/zig-ios-example/blob/dbaf621051e9ae151bf9909673a62baad6a41e2b/build.zig
    if (b.sysroot == null) {
        std.log.warn("You haven't set the path to Apple SDK which may lead to build errors.", .{});
        std.log.warn("Hint: you can the path to Apple SDK with --sysroot <path> flag like so:", .{});
        std.log.warn("  zig build --sysroot $(xcrun --sdk iphoneos --show-sdk-path) -Dtarget=aarch64-ios", .{});
    }

    const absl = b.addStaticLibrary("absl", null);
    absl.setTarget(target);
    absl.setBuildMode(mode);
    absl.force_pic = true;

    link_cpp(absl);
    absl.addIncludeDir("vendor/sources/abseil-cpp");
    absl.addCSourceFiles(&.{
        // fd . vendor/sources/abseil-cpp/absl -e cc
        //  | rg -v '_(benchmark|test).cc'
        //  | rg -v 'exception_safety_testing.cc'
        //  | rg -v 'spinlock_test_common.cc'
        //  | rg -v 'random/benchmarks.cc'
        //  | awk '{ print "\"" $1 "\","}'
        //  | wl-copy
        // as of 02 Feb 2022

        "vendor/sources/abseil-cpp/absl/base/inline_variable_test_a.cc",
        "vendor/sources/abseil-cpp/absl/base/inline_variable_test_b.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/atomic_hook_test_helper.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/cycleclock.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/exponential_biased.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/low_level_alloc.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/periodic_sampler.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/raw_logging.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/scoped_set_env.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/spinlock.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/spinlock_wait.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/strerror.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/sysinfo.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/thread_identity.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/throw_delegate.cc",
        "vendor/sources/abseil-cpp/absl/base/internal/unscaledcycleclock.cc",
        "vendor/sources/abseil-cpp/absl/base/log_severity.cc",
        "vendor/sources/abseil-cpp/absl/container/internal/hash_generator_testing.cc",
        "vendor/sources/abseil-cpp/absl/container/internal/hashtablez_sampler.cc",
        "vendor/sources/abseil-cpp/absl/container/internal/hashtablez_sampler_force_weak_definition.cc",
        "vendor/sources/abseil-cpp/absl/container/internal/raw_hash_set.cc",
        "vendor/sources/abseil-cpp/absl/container/internal/test_instance_tracker.cc",
        "vendor/sources/abseil-cpp/absl/debugging/failure_signal_handler.cc",
        "vendor/sources/abseil-cpp/absl/debugging/internal/address_is_readable.cc",
        "vendor/sources/abseil-cpp/absl/debugging/internal/demangle.cc",
        "vendor/sources/abseil-cpp/absl/debugging/internal/elf_mem_image.cc",
        "vendor/sources/abseil-cpp/absl/debugging/internal/examine_stack.cc",
        "vendor/sources/abseil-cpp/absl/debugging/internal/stack_consumption.cc",
        "vendor/sources/abseil-cpp/absl/debugging/internal/vdso_support.cc",
        "vendor/sources/abseil-cpp/absl/debugging/leak_check.cc",
        "vendor/sources/abseil-cpp/absl/debugging/leak_check_disable.cc",
        "vendor/sources/abseil-cpp/absl/debugging/stacktrace.cc",
        "vendor/sources/abseil-cpp/absl/debugging/symbolize.cc",
        "vendor/sources/abseil-cpp/absl/flags/commandlineflag.cc",
        "vendor/sources/abseil-cpp/absl/flags/flag.cc",
        "vendor/sources/abseil-cpp/absl/flags/flag_test_defs.cc",
        "vendor/sources/abseil-cpp/absl/flags/internal/commandlineflag.cc",
        "vendor/sources/abseil-cpp/absl/flags/internal/flag.cc",
        "vendor/sources/abseil-cpp/absl/flags/internal/private_handle_accessor.cc",
        "vendor/sources/abseil-cpp/absl/flags/internal/program_name.cc",
        "vendor/sources/abseil-cpp/absl/flags/internal/usage.cc",
        "vendor/sources/abseil-cpp/absl/flags/marshalling.cc",
        "vendor/sources/abseil-cpp/absl/flags/parse.cc",
        "vendor/sources/abseil-cpp/absl/flags/reflection.cc",
        "vendor/sources/abseil-cpp/absl/flags/usage.cc",
        "vendor/sources/abseil-cpp/absl/flags/usage_config.cc",
        "vendor/sources/abseil-cpp/absl/hash/internal/city.cc",
        "vendor/sources/abseil-cpp/absl/hash/internal/hash.cc",
        "vendor/sources/abseil-cpp/absl/hash/internal/low_level_hash.cc",
        "vendor/sources/abseil-cpp/absl/hash/internal/print_hash_of.cc",
        "vendor/sources/abseil-cpp/absl/numeric/int128.cc",
        "vendor/sources/abseil-cpp/absl/random/discrete_distribution.cc",
        "vendor/sources/abseil-cpp/absl/random/gaussian_distribution.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/chi_square.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/distribution_test_util.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/gaussian_distribution_gentables.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/nanobenchmark.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/pool_urbg.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/randen.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/randen_benchmarks.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/randen_detect.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/randen_hwaes.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/randen_round_keys.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/randen_slow.cc",
        "vendor/sources/abseil-cpp/absl/random/internal/seed_material.cc",
        "vendor/sources/abseil-cpp/absl/random/seed_gen_exception.cc",
        "vendor/sources/abseil-cpp/absl/random/seed_sequences.cc",
        "vendor/sources/abseil-cpp/absl/status/status.cc",
        "vendor/sources/abseil-cpp/absl/status/status_payload_printer.cc",
        "vendor/sources/abseil-cpp/absl/status/statusor.cc",
        "vendor/sources/abseil-cpp/absl/strings/ascii.cc",
        "vendor/sources/abseil-cpp/absl/strings/charconv.cc",
        "vendor/sources/abseil-cpp/absl/strings/cord.cc",
        "vendor/sources/abseil-cpp/absl/strings/escaping.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/charconv_bigint.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/charconv_parse.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/cord_internal.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/cord_rep_btree.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/cord_rep_btree_navigator.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/cord_rep_btree_reader.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/cord_rep_consume.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/cord_rep_ring.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/cordz_functions.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/cordz_handle.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/cordz_info.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/cordz_sample_token.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/escaping.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/memutil.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/ostringstream.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/pow10_helper.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/str_format/arg.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/str_format/bind.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/str_format/extension.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/str_format/float_conversion.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/str_format/output.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/str_format/parser.cc",
        "vendor/sources/abseil-cpp/absl/strings/internal/utf8.cc",
        "vendor/sources/abseil-cpp/absl/strings/match.cc",
        "vendor/sources/abseil-cpp/absl/strings/numbers.cc",
        "vendor/sources/abseil-cpp/absl/strings/str_cat.cc",
        "vendor/sources/abseil-cpp/absl/strings/str_replace.cc",
        "vendor/sources/abseil-cpp/absl/strings/str_split.cc",
        "vendor/sources/abseil-cpp/absl/strings/string_view.cc",
        "vendor/sources/abseil-cpp/absl/strings/substitute.cc",
        "vendor/sources/abseil-cpp/absl/synchronization/barrier.cc",
        "vendor/sources/abseil-cpp/absl/synchronization/blocking_counter.cc",
        "vendor/sources/abseil-cpp/absl/synchronization/internal/create_thread_identity.cc",
        "vendor/sources/abseil-cpp/absl/synchronization/internal/graphcycles.cc",
        "vendor/sources/abseil-cpp/absl/synchronization/internal/per_thread_sem.cc",
        "vendor/sources/abseil-cpp/absl/synchronization/internal/waiter.cc",
        "vendor/sources/abseil-cpp/absl/synchronization/mutex.cc",
        "vendor/sources/abseil-cpp/absl/synchronization/notification.cc",
        "vendor/sources/abseil-cpp/absl/time/civil_time.cc",
        "vendor/sources/abseil-cpp/absl/time/clock.cc",
        "vendor/sources/abseil-cpp/absl/time/duration.cc",
        "vendor/sources/abseil-cpp/absl/time/format.cc",
        "vendor/sources/abseil-cpp/absl/time/internal/cctz/src/civil_time_detail.cc",
        "vendor/sources/abseil-cpp/absl/time/internal/cctz/src/time_zone_fixed.cc",
        "vendor/sources/abseil-cpp/absl/time/internal/cctz/src/time_zone_format.cc",
        "vendor/sources/abseil-cpp/absl/time/internal/cctz/src/time_zone_if.cc",
        "vendor/sources/abseil-cpp/absl/time/internal/cctz/src/time_zone_impl.cc",
        "vendor/sources/abseil-cpp/absl/time/internal/cctz/src/time_zone_info.cc",
        "vendor/sources/abseil-cpp/absl/time/internal/cctz/src/time_zone_libc.cc",

        // commented to avoid CoreFoundation dependency for now, which is a bit
        // nightmarish with zig's build system when cross-compiling from linux
        // hosts. seems unused by sorbet (so far?)
        //"vendor/sources/abseil-cpp/absl/time/internal/cctz/src/time_zone_lookup.cc",

        "vendor/sources/abseil-cpp/absl/time/internal/cctz/src/time_zone_posix.cc",
        "vendor/sources/abseil-cpp/absl/time/internal/cctz/src/zone_info_source.cc",
        "vendor/sources/abseil-cpp/absl/time/internal/test_util.cc",
        "vendor/sources/abseil-cpp/absl/time/time.cc",
        "vendor/sources/abseil-cpp/absl/types/bad_any_cast.cc",
        "vendor/sources/abseil-cpp/absl/types/bad_optional_access.cc",
        "vendor/sources/abseil-cpp/absl/types/bad_variant_access.cc",
    }, &.{
        //"-pedantic",
        //"-Wall",
        "-W",
        "-Wno-missing-field-initializers",
    });

    const srb_cli = b.addExecutable("srb", null);
    srb_cli.setTarget(target);
    srb_cli.setBuildMode(mode);
    srb_cli.install();

    link_cpp(srb_cli);
    srb_cli.linkLibrary(absl);
    srb_cli.addIncludeDir("vendor/sources/abseil-cpp");
    //srb_cli.linkLibrary(hiredis);

    srb_cli.addIncludeDir(".");
    srb_cli.addCSourceFiles(&.{
        "ast/ArgParsing.cc",
        "ast/Helpers.cc",
        "ast/TreeCopying.cc",
        "ast/TreeSanityChecks.cc",
        "ast/Trees.cc",
        "ast/desugar/Desugar.cc",
        "ast/substitute/Substitute.cc",
        "ast/verifier/Verifier.cc",

        "main/main.cc",
        "main/realmain.cc",
    }, &.{
        //"-pedantic",
        //"-Wall",
        "-W",
        "-Wno-missing-field-initializers",
    });
}

fn link_cpp(it: anytype) void {
    // this becomes linkLibCpp in 0.9+ I believe, but I'm hacking on zig 0.8.1
    // for now
    it.linkSystemLibraryName("c++");

    // this gets implied by linkLibCpp in
    // https://github.com/ziglang/zig/commit/557a097523a8c30c25579db3c634c09c9979d3a2
    // I believe
    it.linkLibC();
}
