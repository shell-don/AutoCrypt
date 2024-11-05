# AutoCrypt
Src contient les scripts d'automatisation de divers algorithmes symétriques classiques (AES, Camellia, SM4, 3DES, Blowfish, CAST5) et deux symétriques dit  en "cascade" (Franck, Lucie). Src contient également l'automatisation d'algorithmes de chiffrements asymétriques (RSA).

![E.Delacroix](Madelaine.jpeg)

La particularité de cette implémentation des algorithmes de chiffrements (symétriques) d'openssl est qu'elle permet de chiffrer N fois un même fichier (appelé surchiffrement) avec des clés différentes, là où la plupart des autres repo se contente d'un seul chiffrement. L'autre avantage est la gestion des clés de chiffrement puisqu'elles sont générées de manière complexe (13 000 bit d'entropie par clé/passage) et stockées automatiquement dans votre base de données KeepassXC, laquelle est protégé par trois facteurs d'authentifications. 
