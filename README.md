<p align="center">
  <img src="logo.png" alt="AutoCrypt logo" width="420">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/POSIX-compliant-blue">
  <img src="https://img.shields.io/badge/shellcheck-clean-brightgreen">
  <img src="https://img.shields.io/badge/do-one--thing--well-blue">
</p>


AutoCrypt is a **POSIX-compliant shell script** designed to **securely encrypt, decrypt, and irreversibly erase files** using strong cryptography and multiple authentication factors.

It combines **OpenSSL** for robust file encryption, **KeePassXC CLI** for secure password generation and storage and an optional **hardware-backed secrets** (e.g. YubiKey).

The core idea is to **turn digital risk into physical risk**:  
if *any* authentication factor is missing, **decryption becomes impossible**.

## ✨ Features

-  Configurable multi-pass encryption
-  Secure password generation via KeePassXC
-  Multiple authentication factors (passwords, files, hardware)
-  Secure erase via encryption-based overwrite
-  Fully POSIX-compliant (`/bin/sh`)
-  Designed for Unix-like systems  
  *(tested on Tails OS and macOS)*


## 🔧 Installation

Download the `autocrypt.sh` script, then edit the **setup section** inside the file:

```sh
#====================== SET UP ======================#

readonly KEYFILEPATH="your_key_file_path"
readonly YUBIKEY="slot:serial"
readonly DBPATH="your_database_path"
readonly DBPWRD="your_database_password"
N=3
````

Make the script executable:

```sh
chmod u+x autocrypt.sh
```

## 👨🏻‍💻 Usage

Display help:

```sh
./autocrypt.sh -h
```

Note: **do not source the script** (`. ./autocrypt.sh`).

```
Usage : autocrypt [mode] [algorithm] [-v|--verbose] file1 file2 ...

Mode :
	-e  --encrypt : encrypt mode
	-d  --decrypt : decrypt mode
	-s  --erase   : erase mode using encryption
	-h  --help    : show help

Cipher algorithm :

	-aes-256-ctr 	    -aes-256-ofb        -aes-256-gcm
	-aes-256-cbc 	    -aes-256-cfb 		-aes-256-cfb8
	-aes-192-ctr 	    -aes-256-ccm        -camellia-256-cbc	
	-camellia-256-cfb8

```

## 🧪 Example

Suppose you have a file and want to **automatically encrypt it 3 times** (configurable) using AES.

```sh
mathis ~ $ cat hello.txt
Hello World !
```

After installing `autocrypt.sh`, plugging in your **YubiKey**, your **KeePassXC database**, and your **keyfile**, configure the script and make it executable.

Encrypt the file:

```sh
mathis ~ $ ./autocrypt.sh -e -aes-256-cbc hello.txt [v|--verbose]
```

If the script is located in `~/Desktop` and your terminal is in `~`, use:

```sh
./Desktop/autocrypt.sh -e -aes-256-cbc hello.txt
```

### Encryption output
(Whithout -v options)
```sh
1 encryption done
2 encryption done
3 encryption done
```

Trying to read the file now:

```sh
mathis ~ $ cat hello.txt
Salted__...binary encrypted data...
```

### Decryption
**You don't need to remember which algorithm you had used the KeepassXC do it for you**
```sh
mathis ~ $ ./autocrypt.sh -d hello.txt [-v|--verbose]
```

Decryption output:

```sh
Decryption 3 done
Decryption 2 done
Decryption 1 done
```

File restored:

```sh
mathis ~ $ cat hello.txt
Hello World !
```

## 📦 Dependencies

AutoCrypt relies on the following tools:

| Tool            | Purpose                       |
| --------------- | ----------------------------- |
| `sh` (POSIX)    | Script execution              |
| `openssl`       | Encryption / Decryption       |
| `keepassxc-cli` | Password generation & storage |
| `shred`         | "Secure" erase                |
| `uname`         | OS detection                  |

Ensure all dependencies are available in your `$PATH` -don't worry if you have a Linux.

## ⚠️ Disclaimer

Losing encryption credentials will result in **permanent data loss**.


