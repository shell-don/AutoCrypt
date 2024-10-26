# AutoCrypt
Chiffrement automatisé d'AES-256-CBC (défault) en s'appuyant sur KeepassXC pour la gestion des clés. (MacOS)

## Installation
Pré-requis
```zsh
brew install KeepassXC && brew install openssl@3 
```
Créer une base de donné avec : un mot de passe fort, une Yubikey et un fichier clé.
Changer les variables Set-up du script (pour le déchiffrement aussi)
```zsh
##########
# Set Up #
##########

KEYFILEPATH=<Key_File_path>
YUBIKEY=<slot[:serial]>
DBPATH=<DataBase_path>
FILEPATH=<File_to_encrypt_path>
```
Rendre éxécutable le script
```zsh
chmod u+x <AutoCrypt.sh_path>
``` 
## Usage
Lancer le script dans un terminal
```zsh
Combien de fois voulez-vous le chiffrer ? 
N
Quel est le mot de passe de la database ?
```
Entrer le mot de passe de la database, et voilà !

Pour le déchiffrement, lacer le script de déchiffrement (AutoCryptR.sh)
```zsh
Combien de fois voulez-vous le déiffrer ? 
N
Quel est le mot de passe de la database ?
```
