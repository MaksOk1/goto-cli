#!/usr/bin/env bash

_goto_rm() {
    local projects_file="$1"
    local name="$2"

    if [ -z "$name" ]; then
        echo "Помилка: Вкажіть назву проєкту для видалення."
        return 1
    fi

    local tmp_file="${projects_file}.tmp.$$"
    if [ -f "$projects_file" ]; then
        grep -v "^${name}|" "$projects_file" > "$tmp_file" || true
        mv "$tmp_file" "$projects_file"
    fi

    echo "Проєкт '$name' видалено."
}