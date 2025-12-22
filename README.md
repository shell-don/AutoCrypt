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
- 📦 POSIX-compliant (/bin/sh)
- 🐧 Designed for Unix-like (tested on Tails OS and MacOS)

## 🔧 Installation

Download the autocrypt.sh script, then, 
modify the set up part inside autocrypt.sh
```sh
#====================== SET UP ======================#

readonly KEYFILEPATH="your_key_file_path"
readonly YUBIKEY=slot:serial
readonly DBPATH="your_database_path"
readonly DBPWRD="your_database_password"
N=3
```
## 👨🏻‍💻 Usage

```sh
./autocrypt.sh -h
```
```sh
Usage :

autocrypt [mode] [algorithm] file1 file2 ...

Mode :

	-e : encrypt mode
	-d : decrypt mode
	-s : erase mode using encryption
	-h : show help

Cipher algorithm :

	-aes-128-cbc               -aes-128-cfb               -aes-128-cfb1
	-aes-128-cfb8              -aes-128-ctr               -aes-128-ecb
	-aes-128-ofb               -aes-192-cbc               -aes-192-cfb
	-aes-192-cfb1              -aes-192-cfb8              -aes-192-ctr
	-aes-192-ecb               -aes-192-ofb               -aes-256-cbc
	-aes-256-cfb               -aes-256-cfb1              -aes-256-cfb8
	-aes-256-ctr               -aes-256-ecb               -aes-256-ofb
	-aes128                    -aes128-wrap               -aes128-wrap-pad
	-aes192                    -aes192-wrap               -aes192-wrap-pad
	-aes256                    -aes256-wrap               -aes256-wrap-pad
	-id-aes128-wrap            -id-aes128-wrap-pad        -id-aes192-wrap
	-id-aes192-wrap-pad        -id-aes256-wrap            -id-aes256-wrap-pad
	-aria-128-cbc              -aria-128-cfb              -aria-128-cfb1
	-aria-128-cfb8             -aria-128-ctr              -aria-128-ecb
	-aria-128-ofb              -aria-192-cbc              -aria-192-cfb
	-aria-192-cfb1             -aria-192-cfb8             -aria-192-ctr
	-aria-192-ecb              -aria-192-ofb              -aria-256-cbc
	-aria-256-cfb              -aria-256-cfb1             -aria-256-cfb8
	-aria-256-ctr              -aria-256-ecb              -aria-256-ofb
	-aria128                   -aria192                   -aria256
	-camellia-128-cbc          -camellia-128-cfb          -camellia-128-cfb1
	-camellia-128-cfb8         -camellia-128-ctr          -camellia-128-ecb
	-camellia-128-ofb          -camellia-192-cbc          -camellia-192-cfb
	-camellia-192-cfb1         -camellia-192-cfb8         -camellia-192-ctr
	-camellia-192-ecb          -camellia-192-ofb          -camellia-256-cbc
	-camellia-256-cfb          -camellia-256-cfb1         -camellia-256-cfb8
	-camellia-256-ctr          -camellia-256-ecb          -camellia-256-ofb
	-camellia128               -camellia192               -camellia256
	-franck                    -lucie

Order for options matter
```
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
