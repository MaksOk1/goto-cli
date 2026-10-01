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

build:
	@echo "[+] Створення папки для збірки..."
	mkdir -p $(BUILD_DIR)

	@echo "[+] Об'єднання всіх скриптів в один файл..."
	cp goto.sh $(BUILD_DIR)/monolith.sh
	
	# Зміна shebang з env на чистий /bin/bash для сумісності з shc
	sed -i '1s|#!/usr/bin/env bash|#!/bin/bash|' $(BUILD_DIR)/monolith.sh
	
	# Тобі вже знайомі заміни source:
	sed -i '/source.*lib\/log.sh/r lib/log.sh' $(BUILD_DIR)/monolith.sh
	sed -i '/source.*lib\/log.sh/d' $(BUILD_DIR)/monolith.sh
	
	sed -i '/source.*src\/add.sh/r src/add.sh' $(BUILD_DIR)/monolith.sh
	sed -i '/source.*src\/add.sh/d' $(BUILD_DIR)/monolith.sh
	
	sed -i '/source.*src\/go.sh/r src/go.sh' $(BUILD_DIR)/monolith.sh
	sed -i '/source.*src\/go.sh/d' $(BUILD_DIR)/monolith.sh
	
	sed -i '/source.*src\/help.sh/r src/help.sh' $(BUILD_DIR)/monolith.sh
	sed -i '/source.*src\/help.sh/d' $(BUILD_DIR)/monolith.sh
	
	sed -i '/source.*src\/list.sh/r src/list.sh' $(BUILD_DIR)/monolith.sh
	sed -i '/source.*src\/list.sh/d' $(BUILD_DIR)/monolith.sh
	
	sed -i '/source.*src\/merge.sh/r src/merge.sh' $(BUILD_DIR)/monolith.sh
	sed -i '/source.*src\/merge.sh/d' $(BUILD_DIR)/monolith.sh
	
	sed -i '/source.*src\/rm.sh/r src/rm.sh' $(BUILD_DIR)/monolith.sh
	sed -i '/source.*src\/rm.sh/d' $(BUILD_DIR)/monolith.sh

	@echo "[+] Обфускація та компіляція в бінарник..."
	shc -r -f $(BUILD_DIR)/monolith.sh -o $(BUILD_DIR)/$(BINARY)

	@echo "[+] Очищення тимчасового коду..."
	rm -f $(BUILD_DIR)/monolith.sh $(BUILD_DIR)/monolith.sh.x.c
	@echo "[OK] Готово! Бінарник тут: $(BUILD_DIR)/$(BINARY)"


clean:
	rm -rf $(BUILD_DIR)