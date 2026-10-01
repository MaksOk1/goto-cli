#!/usr/bin/env bash

INSTALL_DIR="$HOME/.local/share/goto"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/lib/log.sh" ]; then
    . "$SCRIPT_DIR/lib/log.sh"
elif [ -f "$INSTALL_DIR/lib/log.sh" ]; then
    . "$INSTALL_DIR/lib/log.sh"
fi

BLOCK_MARKER="# >>> goto-cli initialize >>>"
BLOCK_END="# <<< goto-cli initialize <<<"

remove_rc() {
    local rc_file="$1"
    if [ -f "$rc_file" ]; then
        local tmp_rc="${rc_file}.tmp.$$"
        local inside_block=0
        > "$tmp_rc"

        while IFS= read -r line || [ -n "$line" ]; do
            if [ "$line" = "$BLOCK_MARKER" ]; then
                inside_block=1
                continue
            fi
            if [ "$line" = "$BLOCK_END" ]; then
                inside_block=0
                continue
            fi
            if [ $inside_block -eq 0 ]; then
                echo "$line" >> "$tmp_rc"
            fi
        done < "$rc_file"

        mv "$tmp_rc" "$rc_file"
        declare -f log_success >/dev/null && log_success "Очищено $rc_file" || echo "Очищено $rc_file"
    fi
}

remove_rc "$HOME/.bashrc"
remove_rc "$HOME/.zshrc"

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    declare -f log_success >/dev/null && log_success "Видалено $INSTALL_DIR" || echo "Видалено $INSTALL_DIR"
fi

declare -f log_success >/dev/null && log_success "goto-cli успішно видалено." || echo "goto-cli успішно видалено."