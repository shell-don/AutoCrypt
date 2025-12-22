# AutoCrypt

AutoCrypt is a **POSIX-compliant shell script** designed to **securely encrypt, decrypt, and securely erase files** using strong cryptography and multiple authentication factors.

It combines:
- **OpenSSL** for encryption
- **KeePassXC CLI** for secure password generation and storage
- Optional **hardware-backed secrets** (e.g. YubiKey)

The goal is to **transform digital risk into physical risk**:  
if one authentication factor is missing, decryption becomes impossible.

## ✨ Features

- 🔐 Multi-pass encryption
- 🔑 Secure password generation via KeePassXC
- 🧠 Multiple authentication factors
- 🧹 Secure erase using encryption overwrite
- 📦 POSIX-compliant (`/bin/sh`)
- 🐧 Designed for Unix-like (tested on Tails OS and MacOS)

## 🔧 Installation

Clone the repository:

```sh
git clone https://github.com/yourusername/autocrypt.git
cd autocrypt

## Usage
'''sh
./autocrypt.sh [mode] [algorithm] file1 file2 ...

## 📦 Dependencies

AutoCrypt relies on the following tools:

| Tool | Purpose |
|----|----|
| `sh` (POSIX) | Script execution |
| `openssl` | Encryption / Decryption |
| `keepassxc-cli` | Password generation & storage |
| `dd` | Secure overwrite |
| `rm` | File removal |
| `uname` | OS detection |

Make sure they are available in your `$PATH`.
