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
