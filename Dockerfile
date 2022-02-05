# bazel seems to be doing some magic to detect OS/version, and fails on the
# debian:bullseye image I previously tried, so we'll just use ubuntu here to
# save one of _numerous_ headaches along the arm64 sorbet path
FROM ubuntu:focal AS build

ENV DEBIAN_FRONTEND=noninteractive

# - perl for shasum(1)
# - libtinfo* due to some transient dependency in C++ land
# - unzip and curl for bazel's sake
# - git for rbenv/installer's sake
# - libssl-dev libreadline-dev zlib1g-dev to build rubies via rbenv
# - the rest copy-pasta and I don't entirely remember
RUN apt update && apt install -y build-essential curl perl unzip python autoconf libffi-dev libgmp-dev libtinfo5 libtinfo-dev python python3 git libssl-dev libreadline-dev zlib1g-dev

# I hate curl|bash but sorbet's packaging scripts expect rbenv and the version
# packaged in focal doesn't know about 2.6.3+ rubies
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
ENV PATH="~/.rbenv/bin:${PATH}"

# upstream's bazel wrapper will pull the 149MB bazel tarball from upstream
# **every single time** if it's not already cached, which in whatever the first
# Docker layer that calls bazel is, it will never be. this is both a ridiculous
# waste of bandwidth (hi, I'm Josh, I have a metered LTE connection out here in
# the woods!) and of time, so we'll force this to be cached as a separate
# Docker layer in the event that build-sorbet-runtime.sh fails (which it
# extremely often does for seemingly-random initialization reasons,
# particularly for arm64 - see copy-pasted traceback below)
#
# #13 68.19 ERROR: Traceback (most recent call last):
# #13 68.19 	File "/main/BUILD", line 1, column 1, in <toplevel>
# #13 68.19 		config_setting(
# #13 68.19 Error: null variable 'config_setting' is referenced before assignment.
# #13 68.31 ERROR: Skipping '//main:sorbet': no such target '//main:sorbet': target 'sorbet' not declared in package 'main' defined by /main/BUILD
# #13 68.32 WARNING: Target pattern parsing failed.
# #13 68.33 ERROR: no such target '//main:sorbet': target 'sorbet' not declared in package 'main' defined by /main/BUILD
COPY ./bazel /bazel
COPY ./WORKSPACE /WORKSPACE
# this will probably fail because, well, there's no actual BUILD file, so just
# ignore the failures - if the actual download of bazel failed, we'll learn
# about it in later steps anyway
RUN ./bazel || true

COPY . .

# these emulate upstream's flow in
# https://github.com/sorbet/sorbet/blob/d9749a23b8ca46d95bf8c1e1643d9a1b1b61fb95/.buildkite/pipeline.yaml
RUN .buildkite/build-sorbet-runtime.sh
RUN .buildkite/build-static-release.sh

FROM scratch AS release

# the intent of the final layer is to simply expose .gem files that can be
# copied into other images for use in applications as local bundler overrides
# (effectively fulfilling Gemfile.lock via a local tarball). if you instead
# want the entire build image to do whatever with, just select that stage via
# CLI/docker-compose/etc. arguments

COPY --from=build /_out_/gems/sorbet-static-*.gem .
COPY --from=build /gems/sorbet/sorbet-*.gem .
COPY --from=build /gems/sorbet-runtime/sorbet-runtime-*.gem .
