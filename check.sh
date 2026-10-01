#!/usr/bin/env bash

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/share/goto}"
BLOCK_MARKER="# >>> goto-cli initialize >>>"

echo "=== Health Check goto-cli ==="
ERR=0

# 1. Перевірка наявності файлів й папки src/
if [ -d "$INSTALL_DIR" ] && [ -f "$INSTALL_DIR/goto.sh" ] && [ -d "$INSTALL_DIR/src" ]; then
    echo "[OK] Основні файли та папка src/ присутні у $INSTALL_DIR"
else
    echo "[FAIL] goto-cli відсутні у $INSTALL_DIR"
    ERR=1
fi

# 2. Перевірка конфігурації у .bashrc / .zshrc
FOUND_RC=0
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc" ] && grep -q "$BLOCK_MARKER" "$rc"; then
        echo "[OK] Конфігураційний блок присутній у $rc"
        FOUND_RC=1
    fi
done

if [ $FOUND_RC -eq 0 ]; then
    echo "[FAIL] Блок ініціалізації відсутній у .bashrc та .zshrc"
    ERR=1
fi

# 3. Синтаксична перевірка завантаження goto.sh й імпорту модулів/функцій
if [ -f "$INSTALL_DIR/goto.sh" ]; then
    if bash -c "source \"$INSTALL_DIR/goto.sh\" && declare -f goto >/dev/null"; then
        echo "[OK] Скрипт goto.sh синтаксично коректний й успішно завантажує всі модулі"
    else
        echo "[FAIL] Помилка завантаження goto.sh або його модулів"
        ERR=1
    fi
fi

echo "-----------------------------"
if [ $ERR -eq 0 ]; then
    echo "Статус: Все працює коректно!"
    exit 0
else
    echo "Статус: Виявлено проблеми з інсталяцією."
    exit 1
fi