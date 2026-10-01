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


BINARY=goto-bin
BUILD_DIR=dist

build:
	@echo "[+] Створення папки для збірки..."
	mkdir -p $(BUILD_DIR)

	@echo "[+] Збирання монолітного коду..."
	# Створюємо чистий файл з правильним shebang
	echo "#!/bin/bash" > $(BUILD_DIR)/monolith.sh
	
	# 1. Вшиваємо всі системні бібліотеки з lib/
	@for file in lib/*.sh; do \
		echo "# --- Вміст $$file ---" >> $(BUILD_DIR)/monolith.sh; \
		cat $$file >> $(BUILD_DIR)/monolith.sh; \
		echo "" >> $(BUILD_DIR)/monolith.sh; \
	done

	# 2. Вшиваємо всі модулі з src/
	@for file in src/*.sh; do \
		echo "# --- Вміст $$file ---" >> $(BUILD_DIR)/monolith.sh; \
		cat $$file >> $(BUILD_DIR)/monolith.sh; \
		echo "" >> $(BUILD_DIR)/monolith.sh; \
	done

	# 3. Додаємо основну логіку з вашого goto.sh (але модифіковану під бінарник)
	@echo "# --- Основна логіка ---" >> $(BUILD_DIR)/monolith.sh
	# Вирізаємо з вашого goto.sh секції динамічного імпорту, залишаючи логіку 'goto()' та автодоповнення
	sed -n '/goto()/,$$p' goto.sh >> $(BUILD_DIR)/monolith.sh

	# 4. Змушуємо бінарник викликати функцію goto з передачею всіх аргументів терміналу
	echo "" >> $(BUILD_DIR)/monolith.sh
	echo 'goto "$$@"' >> $(BUILD_DIR)/monolith.sh

	@echo "[+] Компіляція та обфускація через shc..."
	shc -r -f $(BUILD_DIR)/monolith.sh -o $(BUILD_DIR)/$(BINARY)

	@echo "[+] Очищення тимчасових файлів..."
	rm -f $(BUILD_DIR)/monolith.sh $(BUILD_DIR)/monolith.sh.x.c
	@echo "[OK] Бінарник успішно створено: $(BUILD_DIR)/$(BINARY)"

clean:
	rm -rf $(BUILD_DIR)