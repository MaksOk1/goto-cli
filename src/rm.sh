#!/usr/bin/env bash

_goto_rm() {
    local projects_file="$1"
    local name="$2"

    if [ -z "$name" ]; then
        echo "Помилка: Вкажіть назву проєкту для видалення."
        return 1
    fi

    local tmp_file="${projects_file}.tmp.$$"
    awk -F'|' -v n="$name" '$1 != n' "$projects_file" > "$tmp_file" && mv "$tmp_file" "$projects_file"
    echo "Проєкт '$name' видалено."
}