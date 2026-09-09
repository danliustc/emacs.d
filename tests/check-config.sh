#!/bin/sh
# Test source and bytecode with installed packages and an empty package directory.
set -eu
config_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
check_root=$(mktemp -d "${TMPDIR:-/tmp}/emacs-config-check.XXXXXX")
trap 'rm -rf "$check_root"' EXIT HUP INT TERM
mkdir -p "$check_root/config/tests" "$check_root/empty-elpa"
cp "$config_root/init.el" "$config_root/beorg-init.sample.org" "$check_root/config/"
cp -R "$config_root/lisp" "$config_root/doc" "$check_root/config/"
# Never test a stale compiled file copied from the working tree.
find "$check_root/config/lisp" -name '*.elc' -delete
cp "$config_root/tests/config-tests.el" "$check_root/config/tests/"

run_tests() {
    EMACS_CONFIG_PACKAGE_DIR="$1" emacs --batch -Q \
        -l "$check_root/config/tests/config-tests.el" \
        -f ert-run-tests-batch-and-exit
}

run_tests "$config_root/elpa"
run_tests "$check_root/empty-elpa"
# Compile without activating optional packages: runtime callbacks must not depend
# on third-party macros being available to the compiler.
emacs --batch -Q -L "$check_root/config/lisp" \
    -f batch-byte-compile "$check_root/config/lisp/"*.el
run_tests "$config_root/elpa"
run_tests "$check_root/empty-elpa"
