#!/usr/bin/env bash

# Очищення назви від зовнішніх одинарних та подвійних лапок
_goto_clean_name() {
    local str="$1"
    str="${str#\"}"
    str="${str%\"}"
    str="${str#\'}"
    str="${str%\'}"
    echo "$str"
}

# Перевірка наявності проєкту у файлі маршрутів
_goto_exists() {
    local projects_file="$1"
    local target_project="$2"
    target_project="$(_goto_clean_name "$target_project")"

    [ -z "$target_project" ] && return 1
    [ -f "$projects_file" ] || return 1

    local p_name p_dir
    while IFS='|' read -r p_name p_dir || [ -n "$p_name" ]; do
        p_name="$(_goto_clean_name "$p_name")"
        if [ "$p_name" = "$target_project" ]; then
            return 0
        fi
    done < "$projects_file"

    return 1
}

_goto_go() {
    local projects_file="$1"
    local target_project="$2"
    target_project="$(_goto_clean_name "$target_project")"
    local target_dir=""
    local p_name p_dir

    if [ -f "$projects_file" ]; then
        while IFS='|' read -r p_name p_dir || [ -n "$p_name" ]; do
            p_name="$(_goto_clean_name "$p_name")"
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