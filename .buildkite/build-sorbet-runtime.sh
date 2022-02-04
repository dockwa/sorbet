#!/bin/bash

set -eo pipefail

pushd gems/sorbet-runtime

echo "--- setup :ruby:"
eval "$(rbenv init -)"

runtime_versions=(2.6.6)

for runtime_version in "${runtime_versions[@]}"; do
  rbenv install --skip-existing "$runtime_version"
  rbenv shell "$runtime_version"
  rbenv exec bundle config set path 'vendor/bundle'
  rbenv exec bundle install
done

for runtime_version in "${runtime_versions[@]}"; do
  rbenv shell "$runtime_version"

  rbenv exec ruby --version

  failed=

  echo "+++ rubocop ($runtime_version)"
  if ! rbenv exec bundle exec rake rubocop; then
    failed=1
  fi

  echo "+++ tests ($runtime_version)"
  if ! rbenv exec bundle exec rake test; then
    failed=1
  fi

  if [ "$failed" != "" ]; then
    exit 1
  fi
done

echo "--- build"
# dockwa specific: we have a patchlist that sits atop whatever tag we've most
# recently rebased on. find that tag and use its version number rather than the
# "count the number of commits" approach upstream uses (which leads to version
# mismatches and drift, rapidly)
release_version=$(git describe --tags | cut -d. -f1-3)
sed -i.bak "s/0\\.0\\.0/${release_version}/" sorbet-runtime.gemspec
gem build sorbet-runtime.gemspec
popd

rm -rf _out_
mkdir -p _out_/gems/
cp gems/sorbet-runtime/sorbet-runtime-*.gem _out_/gems/
