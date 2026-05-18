#!/usr/bin/env bash
# alias: make {lock|unlock|status}
# desc: lock/unlock/check the skip-worktree status of lazy-lock.json.
# usage: lazy-lock-sync.sh {lock|unlock|status}

set -euo pipefail
# set -x  # uncomment to debug

__self_path_file=$(readlink -f "${BASH_SOURCE[0]}")
declare -r __self_path_file
declare -r __self_path_dir=${__self_path_file%/*}

fn_lazy_lock_sync() {
  FILE="$__self_path_dir/lazy-lock.json"

  if [ "$1" = "lock" ]; then
    git update-index --skip-worktree "$FILE"
    echo "🔒 $FILE is now protected (skip-worktree on)"
  elif [ "$1" = "unlock" ]; then
    git update-index --no-skip-worktree "$FILE"
    echo "🔓 $FILE is now editable (skip-worktree off)"
  elif [ "$1" = "status" ]; then
    if git ls-files -v "$FILE" | grep -q "^S"; then
      echo "🔒 $FILE is protected (skip-worktree on)"
    else
      echo "🔓 $FILE is editable (skip-worktree off)"
    fi
  else
    echo "Usage: $0 {lock|unlock|status}"
    exit 1
  fi
}

# run directly or source as library
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  fn_lazy_lock_sync "$@"
fi
