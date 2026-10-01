#!/usr/bin/env bash

_goto_list() {
    local projects_file="$1"

    if [ ! -s "$projects_file" ]; then
        echo "Список проєктів порожній."
        return 0
    fi

    echo "Доступні проєкти:"
    if command -v column >/dev/null 2>&1; then
        column -t -s '|' "$projects_file" | sed 's/^/  /'
    else
        sed 's/|/  ->  /' "$projects_file" | sed 's/^/  /'
    fi
}