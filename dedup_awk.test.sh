#!/usr/bin/env bash
set -e
unset dedup_awk
PS1=test source .bashrc
export -f dedup_awk
run_test() {
  path="$1"
  expected="$2"
  actual=$(dedup_awk "${path}")
  if [[ "${expected}" != "${actual}" ]]
  then
    echo "expected ${expected}"
    echo "from path ${path}"
    echo "got ${actual}"
    exit 2
  fi
}
run_test \
  "a:a" \
  "a"
run_test \
  "a:b:c:b:d" \
  "a:b:c:d"
  run_test \
  "a:b:c:b:d:e:d" \
  "a:b:c:d:e"
run_test \
  "/opt/homebrew/bin:/opt/homebrew/sbin:/Users/douglasnaphas/.nvm/versions/node/v16.13.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/sbin" \
  "/opt/homebrew/bin:/opt/homebrew/sbin:/Users/douglasnaphas/.nvm/versions/node/v16.13.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
run_test \
  "a  b:a  b: c d: c d:e" \
  "a  b: c d:e"