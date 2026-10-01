#!/usr/bin/env bash

_goto_list() {
    local projects_file="$1"

    if [ ! -s "$projects_file" ]; then
        echo "Список проєктів порожній."
        return 0
    fi

    echo "Доступні проєкти:"
    local p_name p_dir
    while IFS='|' read -r p_name p_dir || [ -n "$p_name" ]; do
        [ -z "$p_name" ] && continue
        printf "  %-20s -> %s\n" "$p_name" "$p_dir"
    done < "$projects_file"
}