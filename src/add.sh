#!/usr/bin/env bash

_goto_add() {
    local projects_file="$1"
    local name="${2:-$(basename "$(pwd)")}"
    local target_path="${3:-$(pwd)}"

    if [[ -z "$projects_file" ]]; then
        log_error "Не вказано файл проєктів!"
        return 1
    fi

    local tmp_file
    if command -v mktemp >/dev/null 2>&1; then
        tmp_file=$(mktemp "${projects_file}.tmp.XXXXXX")
    else
        tmp_file="${projects_file}.tmp.$$."$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 8)
    fi

    trap 'rm -f "$tmp_file"' RETURN EXIT

    if [ -f "$projects_file" ]; then
        grep -vF "^${name}|" "$projects_file" > "$tmp_file" 2>/dev/null || true
        # mv "$tmp_file" "$projects_file"
    else
        # Якщо файлу немає, створюємо пусту директорію для нього (за потреби) та сам файл
        mkdir -p "$(dirname "$projects_file")" 2>/dev/null || true
        true > "$tmp_file"
    fi

    echo "${name}|${target_path}" >> "$tmp_file"

    if mv "$tmp_file" "$projects_file"; then
        log_success "Проєкт '$name' збережено: $target_path"
    else
        log_error "Не вдалося зберегти зміни у $projects_file"
        return 1
    fi
}