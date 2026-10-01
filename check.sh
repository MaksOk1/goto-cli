#!/usr/bin/env bash

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/share/goto}"
BLOCK_MARKER="# >>> goto-cli initialize >>>"

echo "=== Health Check goto-cli ==="
ERR=0

# 1. Перевірка наявності файлів
if [ -d "$INSTALL_DIR" ] && [ -f "$INSTALL_DIR/goto.sh" ]; then
    echo "[OK] Файли інструменту присутні в $INSTALL_DIR"
else
    echo "[FAIL] goto-cli не знайдено в $INSTALL_DIR"
    ERR=1
fi

# 2. Перевірка конфігурації в RC-файлах
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

# 3. Синтаксична перевірка завантаження goto.sh
if [ -f "$INSTALL_DIR/goto.sh" ]; then
    if bash -c "source \"$INSTALL_DIR/goto.sh\" && declare -f goto >/dev/null"; then
        echo "[OK] Скрипт goto.sh синтаксично коректний і завантажується"
    else
        echo "[FAIL] Помилка завантаження goto.sh"
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