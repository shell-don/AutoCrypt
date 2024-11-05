## Installation

### Symétrique
Pré-requis pour les algorithmes symétriques :

```zsh
brew install KeepassXC && brew install openssl@3 
```
Créer une base de donné avec : un mot de passe fort, une Yubikey et un fichier clé.

### Asymétrique
Pré-requis pour les algorithmes asymétriques (openssl suffit) :

```zsh
brew install openssl@3 
```
## Configuration des scripts

### Symétrique
L'automatisation ne peut se faire que si le script accède au bon fichier. Pour cela, il 
faut configurer les variables dans Set Up avec les bons chemins demandés.

```zsh
##########
# Set Up #
##########

KEYFILEPATH=<Key_File_path>
YUBIKEY=<slot[:serial]>
DBPATH=<DataBase_path>
```
Remarque : Si vous rencontrez un problème d'accès pendant l'éxécution du script, vérifier le PATH

### Asymétrique 

Configurer uniquement le chemin vers la bonne clé (publique ou privée)

Remarque : RSA.sh et RSAR.sh utilise des clés de 4096 bit

## Usage

Dans tous les cas, rendre éxécutable le script souhaité
```zsh
chmod u+x <AutoCrypt.sh_path>
``` 

Enfin, lancer le script voulu dans un terminal.

Ces scripts sont fait pour être cumulé et cumulables facilement, la configuration ne se faisant qu'une fois il est recommandé de chiffré sa clé privé RSA (en plus de la mettre en lieu sûr), par exemple avec l'algorithme symétrique FRANCK, après l'avoir utilisé pour déchiffrer un message que l'on a reçu (RSAR.sh)

Remarque : RSAR.sh ne peut déchiffrer que des fichiers qui ont été chiffré avec RSA.sh

