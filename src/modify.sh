#!/usr/bin/env bash

# Внутрішня функція атомарного оновлення запису у файлі
_goto_update_entry() {
    local projects_file="$1"
    local target_name="$2"
    local new_name="$3"
    local new_path="$4"

    local tmp_file
    if command -v mktemp >/dev/null 2>&1; then
        tmp_file=$(mktemp "${projects_file}.tmp.XXXXXX" 2>/dev/null)
    fi
    [[ -z "$tmp_file" ]] && tmp_file="${projects_file}.tmp.$$.$RANDOM"

    awk -F'|' -v target="$target_name" -v n_name="$new_name" -v n_path="$new_path" '
        BEGIN { OFS="|" }
        $1 == target {
            if (n_name != "") $1 = n_name;
            if (n_path != "") $2 = n_path;
        }
        { print }
    ' "$projects_file" > "$tmp_file" 2>/dev/null

    if mv "$tmp_file" "$projects_file"; then
        return 0
    else
        rm -f "$tmp_file"
        return 1
    fi
}

# Пряме перейменування назви проєкту
_goto_rename() {
    local projects_file="$1"
    local old_name="$2"
    local new_name="$3"

    if [[ -z "$projects_file" || -z "$old_name" || -z "$new_name" ]]; then
        log_error "Недостатньо аргументів для перейменування!"
        return 1
    fi

    if [ ! -f "$projects_file" ] || ! grep -q "^${old_name}|" "$projects_file" 2>/dev/null; then
        log_error "Проєкт '$old_name' не знайдено!"
        return 1
    fi

    if grep -q "^${new_name}|" "$projects_file" 2>/dev/null; then
        log_error "Назва '$new_name' вже зайнята іншим проєктом!"
        return 1
    fi

    if _goto_update_entry "$projects_file" "$old_name" "$new_name" ""; then
        log_success "Проєкт '$old_name' успішно перейменовано на '$new_name'."
        return 0
    else
        log_error "Не вдалося перейменувати проєкт у $projects_file"
        return 1
    fi
}

# Головна команда goto --modify <name> [new_name/new_path]
_goto_modify() {
    local projects_file="$1"
    local target_name="$2"
    local param2="$3" # Може бути новою назвою або новим шляхом

    if [ -z "$target_name" ]; then
        prompt_input "Введіть назву проєкту для модифікації" target_name ""
    fi

    if [ -z "$target_name" ]; then
        log_error "Назву проєкту не вказано."
        return 1
    fi

    local existing_entry
    existing_entry=$(grep "^${target_name}|" "$projects_file" 2>/dev/null | head -n 1)

    if [ -z "$existing_entry" ]; then
        log_error "Проєкт '$target_name' не знайдено у списку!"
        return 1
    fi

    local current_path="${existing_entry#*|}"

    # Якщо другий параметр передано через CLI (наприклад: goto -m test new_test АБО goto -m test /new/path)
    if [ -n "$param2" ]; then
        if [ -d "$param2" ] || [[ "$param2" == /* ]]; then
            _goto_update_entry "$projects_file" "$target_name" "" "$param2"
            log_success "Шлях проєкту '$target_name' змінено на: $param2"
            return 0
        else
            _goto_rename "$projects_file" "$target_name" "$param2"
            return $?
        fi
    fi

    # Інтерактивний режим модифікації
    echo "Модифікація проєкту '$target_name' (Поточний шлях: $current_path)"
    echo "1) Змінити назву проєкту"
    echo "2) Змінити шлях до проєкту"
    echo "3) Змінити назву і шлях"
    echo "0) Скасувати"

    local choice
    prompt_input "Оберіть варіант" choice "1"

    case "$choice" in
        1)
            local new_name=""
            while [ -z "$new_name" ]; do
                prompt_input "Введіть нову назву" new_name ""
                if grep -q "^${new_name}|" "$projects_file" 2>/dev/null; then
                    log_error "Назва '$new_name' вже зайнята!"
                    new_name=""
                fi
            done
            _goto_rename "$projects_file" "$target_name" "$new_name"
            ;;
        2)
            local new_path=""
            prompt_input "Введіть новий шлях" new_path "$(pwd)"
            new_path="${new_path%/}"
            _goto_update_entry "$projects_file" "$target_name" "" "$new_path"
            log_success "Шлях для '$target_name' оновлено на: $new_path"
            ;;
        3)
            local new_name="" new_path=""
            while [ -z "$new_name" ]; do
                prompt_input "Введіть нову назву" new_name ""
                if grep -q "^${new_name}|" "$projects_file" 2>/dev/null; then
                    log_error "Назва '$new_name' вже зайнята!"
                    new_name=""
                fi
            done
            prompt_input "Введіть новий шлях" new_path "$(pwd)"
            new_path="${new_path%/}"
            _goto_update_entry "$projects_file" "$target_name" "$new_name" "$new_path"
            log_success "Проєкт '$target_name' оновлено: '$new_name' -> '$new_path'"
            ;;
        *)
            log_warn "Модифікацію скасовано."
            return 0
            ;;
    esac
}