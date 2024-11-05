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
