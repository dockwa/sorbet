cd test/cli/package-critic || exit 0

../../../main/sorbet --silence-dev-message --stripe-packages --stripe-mode . 2>&1

