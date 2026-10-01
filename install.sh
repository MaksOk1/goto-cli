#!/usr/bin/env bash

INSTALL_DIR="$HOME/.local/share/goto"
SCRIPT_NAME="goto.sh"

echo "Установка goto-cli..."

# 1. Створюємо директорію, копіюємо головний файл та папку src/
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"

if [ -d "lib" ]; then
    cp -r "lib" "$INSTALL_DIR/"
fi

if [ -d "src" ]; then
    cp -r "src" "$INSTALL_DIR/"
fi

# 2. Блок конфігурації у shell rc
BLOCK_MARKER="# >>> goto-cli initialize >>>"
BLOCK_END="# <<< goto-cli initialize <<<"

SOURCE_CMD=$(cat << EOF
$BLOCK_MARKER
if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    . "$INSTALL_DIR/$SCRIPT_NAME"
fi
$BLOCK_END
EOF
)

inject_rc() {
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

        echo "$SOURCE_CMD" >> "$tmp_rc"
        mv "$tmp_rc" "$rc_file"
        echo "Додано конфігурацію в $rc_file"
    fi
}

inject_rc "$HOME/.bashrc"
inject_rc "$HOME/.zshrc"

echo ""
echo "Установку завершено!"