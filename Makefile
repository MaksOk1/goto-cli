SHELL := /usr/bin/env bash

.PHONY: all install uninstall permissions check health-check rehash help

LOG := source ./lib/log.sh 2>/dev/null &&

all: help

# Надання прав на виконання
permissions:
	@$(LOG) log_info "Надання прав на виконання..." || echo "Надання прав на виконання..."
	@chmod +x *.sh src/*.sh lib/*.sh 2>/dev/null || chmod +x *.sh

# Встановлення з автоматичним викликом rehash
install: permissions
	@if [ -f ./install.sh ]; then \
		chmod +x ./install.sh; \
		./install.sh; \
	else \
		$(LOG) log_error "Скрипт install.sh не знайдено." || echo "Помилка: Скрипт install.sh не знайдено."; \
		exit 1; \
	fi	
	@$(MAKE) --no-print-directory rehash

# Видалення
uninstall:
	@if [ -f ./uninstall.sh ]; then \
		chmod +x ./uninstall.sh; \
		./uninstall.sh; \
	else \
		$(LOG) log_error "Скрипт uninstall.sh не знайдено." || echo "Помилка: Скрипт uninstall.sh не знайдено."; \
		exit 1; \
	fi

# Скидання хешу та інструкція щодо оновлення термінала
rehash:
	@$(LOG) log_info "Оновлення хешу shell..." || echo "Оновлення хешу shell..."
	@hash -r 2>/dev/null || true
	@if [ -n "$$ZSH_VERSION" ]; then rehash 2>/dev/null || true; fi
	@echo "--------------------------------------------------------"
	@echo "Примітка: Дочірній процес make не може змінити середовище вашого поточного сеансу."
	@echo "Щоб оновлена функція 'goto' запрацювала прямо зараз, виконайте:"
	@echo "  source ~/.bashrc   # для Bash"
	@echo "  source ~/.zshrc    # для Zsh"
	@echo "  або: exec $$SHELL"
	@echo "--------------------------------------------------------"

# Виклик окремого check.sh
check health-check: permissions
	@./check.sh

help:
	@echo "Доступні команди:"
	@echo "  make install		- Встановити goto-cli та показати команди оновлення"
	@echo "  make rehash		- Скинути хеш та вивести інструкцію для оновлення shell"
	@echo "  make health-check	- Запустити check.sh для діагностики"
	@echo "  make uninstall		- Видалити goto-cli"
	@echo "  make permissions	- Надати +x права всім .sh скриптам"

BINARY=goto
BUILD_DIR=dist

clean:
	@echo "[+] Очищення тимчасових файлів..."
	rm -rf dist
	rm -f *.x.c src/*.x.c lib/*.x.c

build:
	@echo "[+] Створення структури для збірки..."
	mkdir -p dist/src dist/lib
	
	@echo "[+] Компіляція головного файлу..."
	# -r дозволяє запускати бінарник на інших схожих машинах Linux
	# -f вказує файл для компіляції
	shc -r -f goto.sh -o dist/$(BINARY)
	
	@echo "[+] Компіляція залежностей..."
	# Компілюємо файли з src
	for file in src/*.sh; do \
		shc -r -f $$file -o dist/src/$$(basename $$file .sh); \
	done
	
	# Компілюємо файли з lib
	for file in lib/*.sh; do \
		shc -r -f $$file -o dist/lib/$$(basename $$file .sh); \
	done