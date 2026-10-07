# pretty-php-log

> A smart, colorful, real-time **log tailer** for messy PHP/Apache error logs.

`pretty-php-log` is a lightweight Bash utility to monitor your PHP logs in real time — with colorized syntax, array key and variable highlighting, multiline PHP warning support, keyword filtering, and emoji-friendly (or PuTTY-safe) output.

---

## ✨ Features

- 🎨 Colorized: warnings, variables, quoted keys, timestamps
- 🪓 Strip document root paths for clarity
- 🔍 Filter by keyword and PHP log level (warning, fatal, parse)
- 📎 Handles multiline `PHP message:` entries
- 💾 Save cleaned output to a file
- 🖥 PuTTY-safe (no emoji by default), emoji support optional

---

## When to Use This

Use `pretty-php-log` when you want to:

- **Tail** your PHP error log in real time
- Highlight specific warnings (like `Undefined`)
- Quickly debug syntax or fatal errors
- Clean up noisy multi-line `PHP message:` entries
- Strip repetitive docroot paths from output

This tool is designed for **live log monitoring**, not full historical log parsing.

---

## 🚀 Installation

```bash
chmod +x pretty-php-log.sh
sudo mv pretty-php-log.sh /usr/local/bin/pretty-php-log

## ✅ Installation Instructions

1. **Save the script as a file:**

```bash
nano pretty-php-log.sh
# Paste the script
```

2. **Make it executable:**

```bash
chmod +x pretty-php-log.sh
```

3. **Move it to your system PATH:**

```bash
sudo mv pretty-php-log.sh /usr/local/bin/pretty-php-log
```

4. **Now you can use it globally:**

```bash
pretty-php-log -f ~/logs/error_log
```

---

## 🧩 Usage

```bash
pretty-php-log -f <file> [options]
```

### Options:

| Flag           | Alias | Description                                          |
| -------------- | ----- | ---------------------------------------------------- |
| `--file`       | `-f`  | Path to the log file (**required**)                  |
| `--filter`     | `-k`  | Keyword to highlight (e.g. `Undefined`)              |
| `--level`      | `-l`  | Filter by PHP log level: `warning`, `fatal`, `parse` |
| `--strip-path` | `-s`  | Remove this prefix from file paths                   |
| `--emoji`      | `-e`  | Enable emoji (default is PuTTY-safe off)             |
| `--no-emoji`   |       | Explicitly disable emoji                             |
| `--output`     | `-o`  | Save cleaned output to file                          |
| `--max-lines`  | `-m`  | Show last N lines before tailing                     |
| `--help`       | `-h`  | Show usage instructions                              |

---

## 🧪 Examples

```bash
# Basic usage
pretty-php-log -f ~/logs/error_log

# Filter for 'Undefined'
pretty-php-log -f ~/logs/error_log -k Undefined

# Show only Fatal errors, with emoji
pretty-php-log -f ~/logs/error_log -l fatal -e

# Trim document root
pretty-php-log -f ~/logs/error_log -s "/var/www/html/"

# Log output to a file
pretty-php-log -f ~/logs/error_log -o ~/formatted.log
```

## 🖼 Example Output

Here's what your PHP logs look like with `pretty-php-log`:

![pretty-php-log-demo](https://github.com/user-attachments/assets/42ab01e6-7775-4911-a200-8e12050c3fd4)

![pretty-php-log-demo-e](https://github.com/user-attachments/assets/e67154e2-40d8-4d35-bdab-170298763eb0)



## 🤝 Contributing

We welcome pull requests and ideas! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.


---

## 🙌 Credits

Created by SirCode — Powered by Bash, Perl, and the relentless search for efficiency 🍃



