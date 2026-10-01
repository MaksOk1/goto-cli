#!/usr/bin/env bash

# Визначення директорії, де лежить goto.sh
_goto_find_dir() {
    local src=""
    if [ -n "$BASH_SOURCE" ]; then
        src="${BASH_SOURCE[0]}"
    elif [ -n "$ZSH_VERSION" ]; then
        src="${(%):-%x}"
    fi

    if [ -n "$src" ] && [ -f "$src" ]; then
        dirname "$src"
    else
        echo "$HOME/.local/share/goto"
    fi
}

_GOTO_DIR="$(_goto_find_dir)"

# Підключення системних бібліотек із lib/
if [ -d "$_GOTO_DIR/lib" ]; then
    for _lib in "$_GOTO_DIR/lib"/*.sh; do
        [ -f "$_lib" ] && . "$_lib"
    done
    unset _lib
fi

# Імпорт усіх модулів із src/
if [ -d "$_GOTO_DIR/src" ]; then
    for _mod in "$_GOTO_DIR/src"/*.sh; do
        [ -f "$_mod" ] && . "$_mod"
    done
    unset _mod
fi

goto() {
    local projects_file="${GOTO_PROJECTS_FILE:-$HOME/.project_routes}"
    # Створюємо файл, якщо його немає
    touch "$projects_file"

    case "$1" in
        ""|-l|--list)
            _goto_list "$projects_file"
            ;;
        -h|--help)
            _goto_help
            ;;
        -a|--add)
            _goto_add "$projects_file" "$2" "$3"
            ;;
        -m|--modify|--change)
            _goto_modify "$projects_file" "$2" "$3"
            ;;
        -r|--rm|--remove)
            _goto_rm "$projects_file" "$2"
            ;;
        *)
            _goto_go "$projects_file" "$1"
            ;;
    esac
}

# Автодоповнення назв проєктів (Bash/Zsh)
_goto_complete() {
    local projects_file="${GOTO_PROJECTS_FILE:-$HOME/.project_routes}"
    [ -f "$projects_file" ] || return 0

    local cur="${COMP_WORDS[COMP_CWORD]}"
    local list=""
    local p_name p_dir

    while IFS='|' read -r p_name p_dir || [ -n "$p_name" ]; do
        [ -n "$p_name" ] && list="$list $p_name"
    done < "$projects_file"

    if [ -n "$ZSH_VERSION" ]; then
        reply=(${=list})
    else
        COMPREPLY=($(compgen -W "$list" -- "$cur"))
    fi
}

if [ -n "$BASH_VERSION" ]; then
    complete -F _goto_complete goto
elif [ -n "$ZSH_VERSION" ]; then
    compctl -K _goto_complete goto
fi
