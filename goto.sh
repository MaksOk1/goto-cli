#!/usr/bin/env bash

goto() {
    local projects_file="${GOTO_PROJECTS_FILE:-$HOME/.project_routes}"
    
    # Створюємо файл, якщо його немає
    touch "$projects_file"

    # Якщо без аргументів або з прапорцем -l / --list
    if [ -z "$1" ] || [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
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
        return 0
    fi

    # Довідка: goto --help
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        echo "Використання:"
        echo "  goto                      - Список усіх проєктів"
        echo "  goto <назва>              - Перехід до проєкту"
        echo "  goto --add <назва> [шлях] - Зберегти поточну (або вказану) папку"
        echo "  goto --remove <назва>     - Видалити проєкт зі списку"
        return 0
    fi

    # Додавання: goto --add назва [шлях]
    if [ "$1" = "--add" ] || [ "$1" = "-a" ]; then
        if [ -z "$2" ]; then
            echo "Помилка: Вкажіть назву проєкту (наприклад: goto --add myproject)"
            return 1
        fi
        local name="$2"
        local path="${3:-$(pwd)}"

        # Безпечно видаляємо старий запис через mktemp + awk (кросплатформенно)
        local tmp_file
        tmp_file=$(mktemp)
        awk -F'|' -v n="$name" '$1 != n' "$projects_file" > "$tmp_file" && mv "$tmp_file" "$projects_file"

        # Записуємо новий проєкт у форматі: назва|шлях
        echo "${name}|${path}" >> "$projects_file"
        echo "Проєкт '$name' збережено для: $path"
        return 0
    fi

    # Видалення: goto --remove назва
    if [ "$1" = "--remove" ] || [ "$1" = "-r" ] || [ "$1" = "--rm" ]; then
        if [ -z "$2" ]; then
            echo "Помилка: Вкажіть назву проєкту для видалення."
            return 1
        fi
        local name="$2"
        local tmp_file
        tmp_file=$(mktemp)
        awk -F'|' -v n="$name" '$1 != n' "$projects_file" > "$tmp_file" && mv "$tmp_file" "$projects_file"
        echo "Проєкт '$name' видалено."
        return 0
    fi

    # Пошук шляху та перехід
    local target_dir
    target_dir=$(awk -F'|' -v p="$1" '$1 == p {print $2}' "$projects_file")

    if [ -n "$target_dir" ] && [ -d "$target_dir" ]; then
        cd "$target_dir" || return 1
    else
        echo "Помилка: Проєкт '$1' не знайдено або папка '$target_dir' не існує."
        return 1
    fi
}

# Автодоповнення назв проєктів (Bash/Zsh)
_goto_complete() {
    local projects_file="${GOTO_PROJECTS_FILE:-$HOME/.project_routes}"
    [ -f "$projects_file" ] || return 0
    
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local list
    list=$(awk -F'|' '{print $1}' "$projects_file")
    
    if [ -n "$ZSH_VERSION" ]; then
        reply=($(echo "$list"))
    else
        COMPREPLY=($(compgen -W "$list" -- "$cur"))
    fi
}

if [ -n "$BASH_VERSION" ]; then
    complete -F _goto_complete goto
elif [ -n "$ZSH_VERSION" ]; then
    compctl -K _goto_complete goto
fi
# EOF