#!/usr/bin/env bash

_goto_rm() {
    local projects_file="$1"
    local name="$(_goto_clean_name "$2")"

    if [ -z "$name" ]; then
        log_error "Помилка: Вкажіть назву проєкту для видалення."
        return 1
    fi

    local tmp_file="${projects_file}.tmp.$$"
    if [ -f "$projects_file" ]; then
        grep -v "^${name}|" "$projects_file" > "$tmp_file" 2>/dev/null || true
        mv "$tmp_file" "$projects_file"
    fi

    log_success "Проєкт '$name' видалено."
}