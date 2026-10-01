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

    local overwrite=true

    # Перевірка наявності існуючого проєкту
    if [ -f "$projects_file" ]; then
        local existing_entry
        existing_entry=$(grep "^${name}|" "$projects_file" 2>/dev/null | head -n 1)

        if [ -n "$existing_entry" ]; then
            local old_path="${existing_entry#*|}"
            
            # Запитуємо користувача через /dev/tty
            printf "Проєкт '%s' вже існує (%s).\nПерезаписати шлях? [Y/n]: " "$name" "$old_path"
            local reply
            read -r reply </dev/tty 2>/dev/null || read -r reply

            case "$reply" in
                [nN]*)
                    overwrite=false
                    ;;
                *)
                    overwrite=true
                    ;;
            esac
        fi
    fi

    # Безпечне створення тимчасового файлу
    local tmp_file
    if command -v mktemp >/dev/null 2>&1; then
        tmp_file=$(mktemp "${projects_file}.tmp.XXXXXX" 2>/dev/null)
    fi
    if [[ -z "$tmp_file" ]]; then
        tmp_file="${projects_file}.tmp.$$.$RANDOM"
    fi

    # Формування нового вмісту
    if [ -f "$projects_file" ]; then
        if [ "$overwrite" = true ]; then
            grep -v "^${name}|" "$projects_file" > "$tmp_file" 2>/dev/null || true
        else
            cat "$projects_file" > "$tmp_file" 2>/dev/null || true
        fi
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