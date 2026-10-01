#!/usr/bin/env bash

# Перейменування існуючого проєкту у файлі маршрутів
_goto_rename() {
    local projects_file="$1"
    local old_name="$2"
    local new_name="$3"

    if [[ -z "$projects_file" || -z "$old_name" || -z "$new_name" ]]; then
        log_error "Недостатньо аргументів для перейменування!"
        return 1
    fi

    if [ ! -f "$projects_file" ]; then
        log_error "Файл проєктів відсутній!"
        return 1
    fi

    if ! grep -q "^${old_name}|" "$projects_file" 2>/dev/null; then
        log_error "Проєкт '$old_name' не знайдено!"
        return 1
    fi

    if grep -q "^${new_name}|" "$projects_file" 2>/dev/null; then
        log_error "Назва '$new_name' вже зайнята іншим проєктом!"
        return 1
    fi

    local tmp_file
    if command -v mktemp >/dev/null 2>&1; then
        tmp_file=$(mktemp "${projects_file}.tmp.XXXXXX" 2>/dev/null)
    fi
    [[ -z "$tmp_file" ]] && tmp_file="${projects_file}.tmp.$$.$RANDOM"

    # Безпечно міняємо $1 (назву) через awk
    awk -F'|' -v old="$old_name" -v new="$new_name" 'BEGIN{OFS="|"} $1==old {$1=new} {print}' "$projects_file" > "$tmp_file" 2>/dev/null

    if mv "$tmp_file" "$projects_file"; then
        log_success "Проєкт '$old_name' успішно перейменовано на '$new_name'."
        return 0
    else
        rm -f "$tmp_file"
        log_error "Не вдалося перейменувати проєкт у $projects_file"
        return 1
    fi
}