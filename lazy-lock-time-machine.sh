#!/usr/bin/env bash
# alias: make time-machine [commit_hash]
# desc: Restore lazy-lock.json from a past commit (fzf interactive or by hash).
# usage: lazy-lock-time-machine.sh [commit_hash]

__self_path_file=$(readlink -f "${BASH_SOURCE[0]}")
declare -r __self_path_file
declare -r __self_path_dir=${__self_path_file%/*}

fn_lazy_lock_time_machine() {
  local commit_hash=${1}

  if [ -z "${commit_hash}" ]; then
    commit_hash=$(git log --oneline --format="%h %ad %s" --date=short lazy-lock.json | fzf | awk '{print $1}')
  fi

  git checkout "${commit_hash}" -- "${_self_path_dir_}/lazy-lock.json"
}

fn_lazy_lock_time_machine "$@"
