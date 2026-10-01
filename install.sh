#!/usr/bin/env bash

INSTALL_DIR="$HOME/.local/share/goto"
SCRIPT_NAME="goto.sh"

echo "Установка goto-cli..."

# 1. Створюємо директорію та копіюємо файл
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"

# 2. Блок, який додаватиметься у конфіги shell
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
        # Видаляємо старий блок, якщо він уже існував
        sed -i.bak "/$BLOCK_MARKER/,/$BLOCK_END/d" "$rc_file" && rm -f "${rc_file}.bak"
        # Додаємо новий блок
        echo "" >> "$rc_file"
        echo "$SOURCE_CMD" >> "$rc_file"
        echo "Додано конфігурацію в $rc_file"
    fi
}

inject_rc "$HOME/.bashrc"
inject_rc "$HOME/.zshrc"

echo ""
echo "Установку завершено!"
echo "Перезапустіть термінал або виконайте: source ~/.bashrc (або ~/.zshrc)"
echo ""
echo "Для початку використання виконайте: goto"
echo ""