#!/usr/bin/env bash

_goto_add() {
    local projects_file="$1"
    local name="$2"
    local path="${3:-$(pwd)}"

    if [ -z "$name" ]; then
        echo "Помилка: Вкажіть назву проєкту (наприклад: goto --add myproject)"
        return 1
    fi

    local tmp_file="${projects_file}.tmp.$$"
    if [ -f "$projects_file" ]; then
        grep -v "^${name}|" "$projects_file" > "$tmp_file" || true
        mv "$tmp_file" "$projects_file"
    fi

    echo "${name}|${path}" >> "$projects_file"
    echo "Проєкт '$name' збережено: $path"
}