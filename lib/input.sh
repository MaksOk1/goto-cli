#!/usr/bin/env bash

# Читання з /dev/tty з підтримкою дефолтного значення
prompt_input() {
    local prompt_msg="$1"
    local var_name="$2"
    local default_val="$3"

    if [ -n "$default_val" ]; then
        printf "%s [%s]: " "$prompt_msg" "$default_val"
    else
        printf "%s: " "$prompt_msg"
    fi

    local input
    read -r input </dev/tty 2>/dev/null || read -r input

    if [ -z "$input" ] && [ -n "$default_val" ]; then
        eval "$var_name=\"$default_val\""
    else
        eval "$var_name=\"$input\""
    fi
}

# Запит підтвердження Yes/No (повертає 0 для Yes, 1 для No)
prompt_confirm() {
    prompt_msg="$1"
    local default_yes="${2:-true}" # true = [Y/n], false = [y/N]

    local prompt_suffix="[Y/n]"
    [ "$default_yes" = false ] && prompt_suffix="[y/N]"

    printf "%s %s: " "$prompt_msg" "$prompt_suffix"
    local reply
    read -r reply </dev/tty 2>/dev/null || read -r reply

    case "$reply" in
        [yY]*) return 0 ;;
        [nN]*) return 1 ;;
        "")
            if [ "$default_yes" = true ]; then
                return 0
            else
                return 1
            fi
            ;;
        *) return 1 ;;
    esac
}