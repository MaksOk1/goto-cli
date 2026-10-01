#!/usr/bin/env bash

_goto_go() {
    local projects_file="$1"
    local target_project="$2"
    local target_dir=""
    local p_name p_dir

    if [ -f "$projects_file" ]; then
        while IFS='|' read -r p_name p_dir || [ -n "$p_name" ]; do
            if [ "$p_name" = "$target_project" ]; then
                target_dir="$p_dir"
                break
            fi
        done < "$projects_file"
    fi

    if [ -n "$target_dir" ] && [ -d "$target_dir" ]; then
        cd "$target_dir" || return 1
    else
        log_error "Проєкт '$target_project' не знайдено або папка '$target_dir' не існує."
        return 1
    fi
}