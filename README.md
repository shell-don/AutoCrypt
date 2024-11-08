# AutoCrypt
Src contient les scripts d'automatisation de divers algorithmes symétriques classiques (AES, Camellia, SM4, 3DES, Blowfish, CAST5) et deux symétriques dit  en "cascade" (Franck, Lucie). Src contient également l'automatisation d'algorithmes de chiffrements asymétriques (RSA).

![E.Delacroix](Madelaine.jpeg)

La particularité de cette implémentation des algorithmes de chiffrements (symétriques) d'openssl est qu'elle permet de chiffrer N fois un même fichier (appelé surchiffrement) avec des clés différentes, là où la plupart des autres repo se contente d'un seul chiffrement. L'autre avantage est la gestion des clés de chiffrement puisqu'elles sont générées de manière complexe (13 000 bit d'entropie par clé/passage) et stockées automatiquement dans votre base de données KeepassXC, laquelle est protégé par trois facteurs d'authentifications. 


## Installation

#### Symétrique
Pré-requis pour les algorithmes symétriques :

```zsh
brew install KeepassXC && brew install openssl@3 
```
(Pour les algorithmes asymétriques openssl suffit)
Créer une base de données avec : un mot de passe fort, une Yubikey et un fichier clé.

#### Génération de clé asymétrique
 
RSA
```zsh
openssl genpkey -algorithm RSA -out ~/desktop/ClePrive.pem -pkeyopt rsa_keygen_bits:4096
openssl rsa -pubout -in ~/desktop/ClePrive.pem -out ~/desktop/ClePublique.pem
```
Échange de clés Diffie-Hellman
```zsh
openssl ecparam -name prime256v1 -genkey -noout -out ~/desktop/ecdh_private.pem
openssl ec -in ~/desktop/ecdh_private.pem -pubout -out ~/desktop/ecdh_public.pem
```
## Configuration des scripts

```zsh
##########
# Set Up #
##########

KEYFILEPATH=<Key_File_path>
YUBIKEY=<slot[:serial]>
DBPATH=<DataBase_path>
```
Remarque : Si vous rencontrez un problème d'accès pendant l'éxécution du script, vérifier le PATH

## Usage

Dans tous les cas, rendre éxécutable le script souhaité
```zsh
chmod u+x <AutoCrypt.sh_path>
``` 

Enfin, lancer le script voulu dans un terminal.

Ces scripts sont fait pour être cumulés et cumulables facilement, la configuration ne se faisant qu'une fois il est recommandé de chiffrer sa clé privé (en plus de la mettre en lieu sûr), par exemple avec l'algorithme symétrique en "cascade" FRANCK, après l'avoir utilisé.

Remarque : RSAR.sh ne peut déchiffrer que des fichiers qui ont été chiffré avec RSA.sh
