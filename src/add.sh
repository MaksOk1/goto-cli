#!/usr/bin/env bash

_goto_add() {
    local projects_file="$1"
    local name="${2:-$(basename "$(pwd)")}"
    local target_path="${3:-$(pwd)}"

    if [[ -z "$projects_file" ]]; then
        log_error "Не вказано файл проєктів!"
        return 1
    fi

    # Гарантуємо існування директорії
    mkdir -p "$(dirname "$projects_file")" 2>/dev/null || true

    # Безпечне створення тимчасового файлу
    local tmp_file
    if command -v mktemp >/dev/null 2>&1; then
        tmp_file=$(mktemp "${projects_file}.tmp.XXXXXX" 2>/dev/null)
    fi
    if [[ -z "$tmp_file" ]]; then
        tmp_file="${projects_file}.tmp.$$.$RANDOM"
    fi

    # Фільтрація та додавання нового запису
    if [ -f "$projects_file" ]; then
        grep -v "^${name}|" "$projects_file" > "$tmp_file" 2>/dev/null || true
        # mv "$tmp_file" "$projects_file"
    else
        : > "$tmp_file"
    fi

    echo "${name}|${target_path}" >> "$tmp_file"

    # Атомарна заміна файлу
    if mv "$tmp_file" "$projects_file"; then
        log_success "Проєкт '$name' збережено: $target_path"
    else
        rm -f "$tmp_file"
        log_error "Не вдалося зберегти зміни у $projects_file"
        return 1
    fi
}