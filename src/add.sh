#!/usr/bin/env bash

_goto_add() {
    local projects_file="$1"
    local name="$2"
    local path="${3:-$(pwd)}"

    if [ -z "$name" ]; then
        echo "Помилка: Вкажіть назву проєкту (наприклад: goto --add myproject)"
        return 1
    fi

    local tmp_file
    tmp_file=$(mktemp)
    awk -F'|' -v n="$name" '$1 != n' "$projects_file" > "$tmp_file" && mv "$tmp_file" "$projects_file"

    echo "${name}|${path}" >> "$projects_file"
    echo "Проєкт '$name' збережено для: $path"
}