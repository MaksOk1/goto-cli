#!/usr/bin/env bash

_goto_add() {
    local projects_file="$1"
    local raw_name="${2:-$(basename "$(pwd)")}"
    local name="$(_goto_clean_name "$raw_name")"
    local target_path="${3:-$(pwd)}"

    if [[ -z "$projects_file" ]]; then
        log_error "Не вказано файл проєктів!"
        return 1
    fi

    # Гарантуємо існування директорії
    mkdir -p "$(dirname "$projects_file")" 2>/dev/null || true

    local match_by_name=""
    local match_by_path=""

    if [ -f "$projects_file" ]; then
        match_by_name=$(grep "^${name}|" "$projects_file" 2>/dev/null | head -n 1)
        match_by_path=$(grep "|${target_path}$" "$projects_file" 2>/dev/null | head -n 1)
    fi

    # Повний збіг
    if [ -n "$match_by_name" ] && [ "${match_by_name#*|}" = "$target_path" ]; then
        log_info "Проєкт '$name' вже існує за шляхом '$target_path'."
        return 0
    fi

    # Шлях вже має іншу назву проєкту (додавання дубліката)
    if [ -n "$match_by_path" ] && [ -z "$match_by_name" ]; then
        local existing_name="${match_by_path%%|*}"
        log_warn "Шлях '$target_path' вже прив'язаний до проєкту '$existing_name'."
        if ! prompt_confirm "Додати ще одну назву ('$name') для цього ж шляху?" true; then
            log_warn "Створення проєкту скасовано."
            return 0
        fi
    fi

    # Назва вже зайнята іншим шляхом
    if [ -n "$match_by_name" ]; then
        local old_path="${match_by_name#*|}"
        log_warn "Проєкт з назвою '$name' вже існує для шляху '$old_path'."

        if prompt_confirm "Вказати іншу назву для НОВОГО проєкту ($target_path)?" true; then
            local new_name=""
            while [ -z "$new_name" ]; do
                prompt_input "Введіть нову назву для '$target_path'" new_name ""
                new_name="$(_goto_clean_name "$new_name")"
                if grep -q "^${new_name}|" "$projects_file" 2>/dev/null; then
                    log_error "Назва '$new_name' також зайнята!"
                    new_name=""
                fi
            done
            name="$new_name"
        elif prompt_confirm "Перейменувати СТАРИЙ проєкт '$name' ($old_path)?" false; then
            local old_new_name=""
            while [ -z "$old_new_name" ]; do
                prompt_input "Введіть нову назву для старого проєкту" old_new_name ""
                old_new_name="$(_goto_clean_name "$old_new_name")"
                if grep -q "^${old_new_name}|" "$projects_file" 2>/dev/null; then
                    log_error "Назва '$old_new_name' вже зайнята!"
                    old_new_name=""
                fi
            done
            _goto_rename "$projects_file" "$name" "$old_new_name"
        elif prompt_confirm "Перезаписати шлях проєкту '$name' на '$target_path'?" false; then
            # Продовжуємо стандартне збереження для перезапису
            :
        else
            log_warn "Створення проєкту скасовано."
            return 0
        fi
    fi

    # Безпечне створення тимчасового файлу
    local tmp_file
    if command -v mktemp >/dev/null 2>&1; then
        tmp_file=$(mktemp "${projects_file}.tmp.XXXXXX" 2>/dev/null)
    fi
    [[ -z "$tmp_file" ]] && tmp_file="${projects_file}.tmp.$$.$RANDOM"

    # Формування нового вмісту
    if [ -f "$projects_file" ]; then
        grep -v "^${name}|" "$projects_file" > "$tmp_file" 2>/dev/null || true
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