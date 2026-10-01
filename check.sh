#!/usr/bin/env bash

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/share/goto}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/lib/log.sh" ]; then
    . "$SCRIPT_DIR/lib/log.sh"
elif [ -f "$INSTALL_DIR/lib/log.sh" ]; then
    . "$INSTALL_DIR/lib/log.sh"
fi

declare -f log_info >/dev/null && log_info "    Healthcheck started..." || echo "    Healthcheck started..."
ERR=0

# 1. Перевірка наявності файлів й папки src/
if [ -d "$INSTALL_DIR" ] && [ -f "$INSTALL_DIR/goto.sh" ] && [ -d "$INSTALL_DIR/src" ] && [ -d "$INSTALL_DIR/lib" ]; then
    declare -f log_success >/dev/null && log_success "Основні файли, папки lib/ та src/ присутні у $INSTALL_DIR" || echo  "[OK] Основні файли, папки lib/ та src/ присутні у $INSTALL_DIR"
else
    declare -f log_error >/dev/null && log_error "goto-cli або необхідні директорії відсутні у $INSTALL_DIR" || echo "[FAIL] goto-cli або необхідні директорії відсутні у $INSTALL_DIR"
    ERR=1
fi

# 2. Перевірка конфігурації у .bashrc / .zshrc
FOUND_RC=0
BLOCK_MARKER="# >>> goto-cli initialize >>>"
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc" ] && grep -q "$BLOCK_MARKER" "$rc"; then
        declare -f log_success >/dev/null && log_success "Конфігураційний блок присутній у $rc" || echo "[OK] Конфігураційний блок присутній у $rc"
        FOUND_RC=1
    fi
done

if [ $FOUND_RC -eq 0 ]; then
    log_error "[FAIL] Блок ініціалізації відсутній у .bashrc та .zshrc"
    ERR=1
fi

# 3. Синтаксична перевірка завантаження goto.sh й імпорту модулів/функцій
if [ -f "$INSTALL_DIR/goto.sh" ]; then
    if bash -c "source \"$INSTALL_DIR/goto.sh\" && declare -f goto >/dev/null"; then
        declare -f log_success >/dev/null && log_success "Скрипт goto.sh синтаксично коректний й успішно завантажує всі модулі" || echo "[OK] Скрипт goto.sh синтаксично коректний й успішно завантажує всі модулі"
    else
        declare -f log_error >/dev/null && log_error "Помилка завантаження goto.sh або його модулів" || echo "[FAIL] Помилка завантаження goto.sh або його модулів"
        ERR=1
    fi
fi

declare -f log_info >/dev/null && log_info "    Healthcheck results:" || echo "    Healthcheck results:"
if [ $ERR -eq 0 ]; then
    declare -f log_success >/dev/null && log_success "Все працює коректно!" || echo "Статус: Все працює коректно!"
    exit 0
else
    declare -f log_error >/dev/null && log_error "Виявлено проблеми з інсталяцією." || echo "Статус: Виявлено проблеми з інсталяцією."
    exit 1
fi