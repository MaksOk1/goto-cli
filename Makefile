.PHONY: all install uninstall permissions check health-check help

SHELL := /usr/bin/env bash
INSTALL_DIR := $(HOME)/.local/share/goto
BLOCK_MARKER := # >>> goto-cli initialize >>>

all: help

# Надання прав на виконання для всіх .sh скриптів
permissions:
	@echo "Надання прав на виконання для скриптів..."
	@chmod +x install.sh uninstall.sh goto.sh 2>/dev/null || chmod +x *.sh

# Встановлення
install: permissions
	@./install.sh

# Видалення
uninstall:
	@if [ -f ./uninstall.sh ]; then \
		chmod +x ./uninstall.sh; \
		./uninstall.sh; \
	else \
		echo "Помилка: Скрипт uninstall.sh не знайдено."; \
		exit 1; \
	fi

# Аліас для health-check
health-check: check

# Перевірка стану інсталяції
check:
	@echo "=== Health Check goto-cli ==="
	@ERR=0; \
	if [ -d "$(INSTALL_DIR)" ] && [ -f "$(INSTALL_DIR)/goto.sh" ]; then \
		echo "[OK] Файли інструменту присутні в $(INSTALL_DIR)"; \
	else \
		echo "[FAIL] goto-cli не знайдено в $(INSTALL_DIR)"; \
		ERR=1; \
	fi; \
	FOUND_RC=0; \
	for rc in "$(HOME)/.bashrc" "$(HOME)/.zshrc"; do \
		if [ -f "$$rc" ] && grep -q "$(BLOCK_MARKER)" "$$rc"; then \
			echo "[OK] Конфігураційний блок присутній у $$rc"; \
			FOUND_RC=1; \
		fi; \
	done; \
	if [ $$FOUND_RC -eq 0 ]; then \
		echo "[FAIL] Блок ініціалізації відсутній у .bashrc та .zshrc"; \
		ERR=1; \
	fi; \
	if [ -f "$(INSTALL_DIR)/goto.sh" ]; then \
		if bash -c "source $(INSTALL_DIR)/goto.sh && declare -f goto >/dev/null"; then \
			echo "[OK] Скрипт goto.sh синтаксично коректний і імпортується"; \
		else \
			echo "[FAIL] Помилка завантаження goto.sh"; \
			ERR=1; \
		fi; \
	fi; \
	echo "-----------------------------"; \
	if [ $$ERR -eq 0 ]; then \
		echo "Статус: Все працює коректно!"; \
	else \
		echo "Статус: Виявлено проблеми з інсталяцією."; \
		exit 1; \
	fi

help:
	@echo "Доступні команди:"
	@echo "  make install       - Надати права та встановити goto-cli"
	@echo "  make uninstall     - Видалити goto-cli та очистити RC-файли"
	@echo "  make permissions   - Зробити .sh скрипти виконуваними"
	@echo "  make health-check  - Перевірити коректність встановлення"