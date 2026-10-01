#!/usr/bin/env bash

INSTALL_DIR="$HOME/.local/share/goto"
BLOCK_MARKER="# >>> goto-cli initialize >>>"
BLOCK_END="# <<< goto-cli initialize <<<"

remove_rc() {
    local rc_file="$1"
    if [ -f "$rc_file" ]; then
        # Кросплатформенне видалення блоку між маркерами
        if command -v perl >/dev/null 2>&1; then
            perl -i -ne "print unless /$BLOCK_MARKER/../$BLOCK_END/" "$rc_file"
        else
            sed -i.bak "/$BLOCK_MARKER/,/$BLOCK_END/d" "$rc_file" && rm -f "${rc_file}.bak"
        fi
        echo "Очищено $rc_file"
    fi
}

remove_rc "$HOME/.bashrc"
remove_rc "$HOME/.zshrc"

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo "Видалено $INSTALL_DIR"
fi

echo "goto-cli успішно видалено."