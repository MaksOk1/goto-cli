# 🚀 goto-cli

**goto-cli** — проста CLI-утиліта для швидкої навігації між часто використовуваними директоріями в **Bash** та **Zsh**.

Збережіть директорію під короткою назвою:

```bash
goto -a my-project ~/projects/my-project
```

і надалі переходьте до неї:

```bash
goto my-project
```

---

## 📥 Встановлення

```bash
git clone <repository-url>
cd goto-cli
make install
```

Після встановлення оновіть shell:

```bash
source ~/.bashrc
```

Для Zsh:

```bash
source ~/.zshrc
```

Перевірка:

```bash
goto --help
```

> `goto-cli` встановлюється у `~/.local/share/goto` і не потребує `sudo`.

---

## 🗑️ Видалення

У каталозі проєкту:

```bash
make uninstall
```

або:

```bash
./uninstall.sh
```

Буде видалено `goto-cli` та його конфігурацію з `.bashrc` / `.zshrc`.

**Збережені маршрути не видаляються.**

---

# ⚡ Швидкий старт

```bash
cd ~/projects/my-project
goto -a my-project
```

Тепер:

```bash
goto my-project
```

Поверне вас у:

```text
~/projects/my-project
```

Показати всі збережені маршрути:

```bash
goto
```

---

# 🛠️ Основні команди

| Команда                  | Опис                     |
| ------------------------ | ------------------------ |
| `goto`                   | Показати список проєктів |
| `goto <name>`            | Перейти до проєкту       |
| `goto -a <name> [path]`  | Додати проєкт            |
| `goto -m <name>`         | Змінити проєкт           |
| `goto -m <name> <value>` | Змінити назву або шлях   |
| `goto -r <name>`         | Видалити проєкт          |
| `goto -p <name>`         | Явний перехід до проєкту |
| `goto -h`                | Показати довідку         |

Доступні також довгі варіанти:

```text
--add
--modify
--change
--rm
--remove
--project
--list
--help
```

---

# ➕ Додавання

### Поточна директорія

```bash
goto -a my-project
```

У цьому випадку буде використано поточну директорію.

### Вказати шлях

```bash
goto -a my-project ~/projects/my-project
```

### Автоматично взяти назву директорії

```bash
cd ~/projects/my-project
goto -a
```

Alias буде:

```text
my-project
```

---

# ✏️ Зміна проєкту

### Інтерактивний режим

```bash
goto -m my-project
```

Далі можна вибрати:

```text
1) Змінити назву
2) Змінити шлях
3) Змінити назву і шлях
0) Скасувати
```

### Перейменувати

```bash
goto -m my-project new-name
```

### Змінити шлях

```bash
goto -m my-project ~/projects/new-location
```

---

# 🗑️ Видалення

```bash
goto -r my-project
```

Видаляється **лише маршрут**, а не сама директорія.

Наприклад:

```text
my-project → /home/user/projects/my-project
```

після:

```bash
goto -r my-project
```

каталог `/home/user/projects/my-project` залишиться на диску.

---

# 📋 Перегляд маршрутів

```bash
goto
```

або:

```bash
goto -l
```

або:

```bash
goto --list
```

Приклад:

```text
Доступні проєкти:
  frontend             -> /home/user/projects/frontend
  backend              -> /home/user/projects/backend
  website              -> /home/user/projects/website
```

---

# ⌨️ Tab Completion

`goto-cli` підтримує автодоповнення через `Tab` у **Bash** та **Zsh**.

Наприклад:

```bash
goto front<TAB>
```

може доповнити назву проєкту.

Також доступне автодоповнення команд:

```bash
goto --<TAB>
```

---

# 🏷️ Назви, що починаються з `-`

Якщо назва проєкту починається з `-`, використовуйте `-p`:

```bash
goto -p "-my-project"
```

або:

```bash
goto --project "-my-project"
```

---

# 💾 Збереження даних

За замовчуванням маршрути зберігаються у:

```text
~/.project_routes
```

Формат:

```text
назва|шлях
```

Наприклад:

```text
frontend|/home/user/projects/frontend
backend|/home/user/projects/backend
website|/home/user/projects/website
```

---

## ⚙️ Власний файл маршрутів

Можна використати інший файл:

```bash
export GOTO_PROJECTS_FILE="$HOME/.config/goto/routes"
```

Після цього маршрути зберігатимуться у вказаному файлі.

Якщо змінну не задано, використовується:

```text
~/.project_routes
```

---

# 🩺 Перевірка

Перевірити встановлення:

```bash
make health-check
```

або:

```bash
./check.sh
```

Перевіряються:

* файли встановлення;
* каталоги `src/` та `lib/`;
* конфігурація Bash/Zsh;
* завантаження `goto.sh`.

---

# 🔄 Оновлення

Після отримання нової версії:

```bash
git pull
make install
```

Потім оновіть shell:

```bash
source ~/.bashrc
```

або:

```bash
source ~/.zshrc
```

---

# 📂 Структура

```text
goto-cli/
├── goto.sh          # головний файл
├── install.sh       # встановлення
├── uninstall.sh     # видалення
├── check.sh         # health check
├── Makefile
├── src/             # функціональні модулі
│   ├── add.sh
│   ├── go.sh
│   ├── help.sh
│   ├── list.sh
│   ├── merge.sh
│   ├── modify.sh
│   └── rm.sh
├── lib/             # спільні бібліотеки
│   ├── input.sh
│   └── log.sh
└── FUTURE.md
```

---

# 🔧 Для розробки

Основні команди:

```bash
make install
make uninstall
make health-check
make permissions
make rehash
make help
```

Для локального запуску без встановлення:

```bash
source ./goto.sh
```

Після цього:

```bash
goto --help
```

---

# 💡 Як це працює

`goto` — це **shell-функція**, а не звичайний executable.

Це дозволяє виконувати:

```bash
goto my-project
```

і змінювати директорію саме **поточного shell-сеансу**.

Під час встановлення `goto.sh` автоматично підключається через `.bashrc` або `.zshrc`.

---

# 📜 License

Дивіться [`LICENSE`](./LICENSE).
