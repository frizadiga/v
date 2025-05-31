#!/usr/bin/env bash
# alias: 'n/a'
# desc: fn_lazy_lock_time_machine description.
# usage: fn_lazy_lock_time_machine.sh <commit_hash?>
# flags: @WIP:0 @TODO:0 @FIXME:0 @BUG:0 @OPTIMIZE:0 @REFACTOR:0 @DEPRECATED:0

declare -r _self_path_file_=$(readlink -f "$0")
declare -r _self_path_dir_=$(dirname "${_self_path_file_}")

fn_lazy_lock_time_machine() {
  local commit_hash=${1}

  if [ -z "${commit_hash}" ]; then
    commit_hash=$(git log --oneline --format="%h %ad %s" --date=short lazy-lock.json | fzf | awk '{print $1}')
  fi

  git checkout "${commit_hash}" -- "${_self_path_dir_}/lazy-lock.json"
}

fn_lazy_lock_time_machine "$@"
