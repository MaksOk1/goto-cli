````markdown
# 🚀 goto-cli

[🇺🇦 Українська](./README.uk.md)

**goto-cli** — a simple CLI utility for quickly navigating between frequently used directories in **Bash** and **Zsh**.

Save a directory under a short name:

```bash
goto -a my-project ~/projects/my-project
````

and then navigate to it:

```bash
goto my-project
```

---

## 📥 Installation

```bash
git clone <repository-url>
cd goto-cli
make install
```

After installation, reload your shell:

```bash
source ~/.bashrc
```

For Zsh:

```bash
source ~/.zshrc
```

Check the installation:

```bash
goto --help
```

> `goto-cli` is installed to `~/.local/share/goto` and does not require `sudo`.

---

## 🗑️ Uninstallation

From the project directory:

```bash
make uninstall
```

or:

```bash
./uninstall.sh
```

This removes `goto-cli` and its configuration from `.bashrc` / `.zshrc`.

**Saved routes are not deleted.**

---

# ⚡ Quick Start

```bash
cd ~/projects/my-project
goto -a my-project
```

Now:

```bash
goto my-project
```

will take you to:

```text
~/projects/my-project
```

Show all saved routes:

```bash
goto
```

---

# 🛠️ Main Commands

| Command                  | Description                      |
| ------------------------ | -------------------------------- |
| `goto`                   | Show the list of projects        |
| `goto <name>`            | Navigate to a project            |
| `goto -a <name> [path]`  | Add a project                    |
| `goto -m <name>`         | Modify a project                 |
| `goto -m <name> <value>` | Change the name or path          |
| `goto -r <name>`         | Remove a project                 |
| `goto -p <name>`         | Explicitly navigate to a project |
| `goto -h`                | Show help                        |

Long options are also available:

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

# ➕ Adding a Route

### Current Directory

```bash
goto -a my-project
```

The current directory will be used.

### Specify a Path

```bash
goto -a my-project ~/projects/my-project
```

### Automatically Use the Directory Name

```bash
cd ~/projects/my-project
goto -a
```

The alias will be:

```text
my-project
```

---

# ✏️ Modifying a Project

### Interactive Mode

```bash
goto -m my-project
```

You can then choose:

```text
1) Change name
2) Change path
3) Change name and path
0) Cancel
```

### Rename

```bash
goto -m my-project new-name
```

### Change Path

```bash
goto -m my-project ~/projects/new-location
```

---

# 🗑️ Removing a Route

```bash
goto -r my-project
```

Only the **saved route** is removed, not the directory itself.

For example:

```text
my-project → /home/user/projects/my-project
```

after:

```bash
goto -r my-project
```

the directory `/home/user/projects/my-project` will remain on disk.

---

# 📋 Viewing Routes

```bash
goto
```

or:

```bash
goto -l
```

or:

```bash
goto --list
```

Example:

```text
Available projects:
frontend             -> /home/user/projects/frontend
backend              -> /home/user/projects/backend
website              -> /home/user/projects/website
```

---

# ⌨️ Tab Completion

`goto-cli` supports `Tab` completion in **Bash** and **Zsh**.

For example:

```bash
goto front<TAB>
```

may complete the project name.

Command completion is also available:

```bash
goto --<TAB>
```

---

# 🏷️ Names Starting with `-`

If a project name starts with `-`, use `-p`:

```bash
goto -p "-my-project"
```

or:

```bash
goto --project "-my-project"
```

---

# 💾 Data Storage

By default, routes are stored in:

```text
~/.project_routes
```

Format:

```text
name|path
```

For example:

```text
frontend|/home/user/projects/frontend
backend|/home/user/projects/backend
website|/home/user/projects/website
```

---

## ⚙️ Custom Routes File

You can use a different file:

```bash
export GOTO_PROJECTS_FILE="$HOME/.config/goto/routes"
```

Routes will then be stored in the specified file.

If the variable is not set, the default is:

```text
~/.project_routes
```

---

# 🩺 Health Check

Check the installation:

```bash
make health-check
```

or:

```bash
./check.sh
```

The following are checked:

* installation files;
* `src/` and `lib/` directories;
* Bash/Zsh configuration;
* loading of `goto.sh`.

---

# 🔄 Updating

After pulling a new version:

```bash
git pull
make install
```

Then reload your shell:

```bash
source ~/.bashrc
```

or:

```bash
source ~/.zshrc
```

---

# 📂 Project Structure

```text
goto-cli/
├── goto.sh          # main file
├── install.sh       # installation
├── uninstall.sh     # uninstallation
├── check.sh         # health check
├── Makefile
├── src/             # functional modules
│   ├── add.sh
│   ├── go.sh
│   ├── help.sh
│   ├── list.sh
│   ├── merge.sh
│   ├── modify.sh
│   └── rm.sh
├── lib/              # shared libraries
│   ├── input.sh
│   └── log.sh
└── FUTURE.md
```

---

# 🔧 Development

Main commands:

```bash
make install
make uninstall
make health-check
make permissions
make rehash
make help
```

To run locally without installing:

```bash
source ./goto.sh
```

Then:

```bash
goto --help
```

---

# 💡 How It Works

`goto` is a **shell function**, not a regular executable.

This allows:

```bash
goto my-project
```

to change the directory of the **current shell session**.

During installation, `goto.sh` is automatically sourced through `.bashrc` or `.zshrc`.

---

# 📜 License

See [`LICENSE`](./LICENSE).
