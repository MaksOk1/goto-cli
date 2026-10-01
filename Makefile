.PHONY: all install uninstall permissions check health-check rehash help

SHELL := /usr/bin/env bash

all: help

# Надання прав на виконання
permissions:
	@echo "Надання прав на виконання для скриптів..."
	@chmod +x install.sh uninstall.sh goto.sh check.sh 2>/dev/null || chmod +x *.sh

# Встановлення з автоматичним викликом rehash
install: permissions
	@./install.sh
	@echo ""
	@$(MAKE) --no-print-directory rehash

# Видалення
uninstall:
	@if [ -f ./uninstall.sh ]; then \
		chmod +x ./uninstall.sh; \
		./uninstall.sh; \
	else \
		echo "Помилка: Скрипт uninstall.sh не знайдено."; \
		exit 1; \
	fi

# Скидання хешу та інструкція щодо оновлення термінала
rehash:
	@echo "Оновлення таблиць shell..."
	@hash -r 2>/dev/null || true
	@if [ -n "$$ZSH_VERSION" ]; then rehash 2>/dev/null || true; fi
	@echo "--------------------------------------------------------"
	@echo "Примітка: Дочірній процес make не може змінити середовище вашої поточної сесії."
	@echo "Щоб функція 'goto' запрацювала прямо зараз, виконайте:"
	@echo "  source ~/.bashrc   # для Bash"
	@echo "  source ~/.zshrc    # для Zsh"
	@echo "  або простіше: exec $$SHELL"
	@echo "--------------------------------------------------------"

# Виклик окремого check.sh
check health-check: permissions
	@./check.sh

help:
	@echo "Доступні команди:"
	@echo "  make install       - Встановити goto-cli та показати команди оновлення"
	@echo "  make rehash        - Скинути хеш та вивести інструкцію для оновлення shell"
	@echo "  make health-check  - Запустити check.sh для діагностики"
	@echo "  make uninstall     - Видалити goto-cli"
	@echo "  make permissions   - Надати +x права всім .sh скриптам"