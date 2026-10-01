#!/usr/bin/env bash

_goto_add() {
    local projects_file="$1"
    local name="${2:-$(basename "$(pwd)")}"
    local target_path="${3:-$(pwd)}"

    local tmp_file="${projects_file}.tmp.$$"
    if [ -f "$projects_file" ]; then
        grep -v "^${name}|" "$projects_file" > "$tmp_file" 2>/dev/null || true
        mv "$tmp_file" "$projects_file"
    fi

    echo "${name}|${target_path}" >> "$projects_file"
    log_success "Проєкт '$name' збережено: $target_path"
}