#!/usr/bin/env bash

_goto_add() {
    local projects_file="$1"
    local name="$2"
    local target_path="${3:-$(pwd)}"

    if [ -z "$name" ]; then
        echo "Помилка: Вкажіть назву проєкту (наприклад: goto --add myproject)"
        return 1
    fi

    local tmp_file="${projects_file}.tmp.$$"
    if [ -f "$projects_file" ]; then
        local p_name p_dir
        > "$tmp_file"
        while IFS='|' read -r p_name p_dir || [ -n "$p_name" ]; do
            if [ "$p_name" != "$name" ] && [ -n "$p_name" ]; then
                echo "${p_name}|${p_dir}" >> "$tmp_file"
            fi
        done < "$projects_file"
        mv "$tmp_file" "$projects_file"
    fi

    echo "${name}|${target_path}" >> "$projects_file"
    echo "Проєкт '$name' збережено: $target_path"
}