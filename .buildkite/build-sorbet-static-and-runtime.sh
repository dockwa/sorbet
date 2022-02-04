#!/bin/bash

set -eo pipefail

pushd gems/sorbet-static-and-runtime

echo "--- setup :ruby:"
eval "$(rbenv init -)"

runtime_versions=(2.6.3 2.7.2)

for runtime_version in "${runtime_versions[@]}"; do
  rbenv install --skip-existing "$runtime_version"
  rbenv shell "$runtime_version"
done

echo "--- build"
# dockwa specific: we have a patchlist that sits atop whatever tag we've most
# recently rebased on. find that tag and use its version number rather than the
# "count the number of commits" approach upstream uses (which leads to version
# mismatches and drift, rapidly)
release_version=$(git describe --tags | cut -d. -f1-3)
sed -i.bak "s/0\\.0\\.0/${release_version}/" sorbet-static-and-runtime.gemspec
gem build sorbet-static-and-runtime.gemspec

popd

rm -rf _out_
mkdir -p _out_/gems/
cp gems/sorbet-static-and-runtime/sorbet-static-and-runtime-*.gem _out_/gems/
