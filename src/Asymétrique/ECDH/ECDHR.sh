#!/bin/sh
# Autaumatisation de l'échange de clé Diffie-Hellman (déchiffrement)
# pré-requis : avoir la clé publique de la personne tiers et votre clé privé

##########
# Se† Up #
##########

PRIVATEKEY=<private_key_path>
PUBLICKEY=<public_key_path>

########
# Pa†H # 
########

PATH=/usr/bin:/bin:/usr/sbin:/sbin:/dev:/opt/homebrew/bin:/opt/homebrew/Cellar/openssl@3/3.3.2/bin:

########
# Co∂e #
########

echo "Quel est le chemin du fichier à chiffrer ?"
read FILEPATH

# Génération du secret commun 
openssl pkeyutl -derive -inkey $PRIVATEKEY -peerkey $PUBLICKEY -out ~/desktop/secret.bin
SECRET=~/desktop/secret.bin
CLE=$(openssl dgst -sha256 -r $SECRET | awk '{print $1}')
rm $SECRET

# déchiffrement du fichier (symétrique en cascade)
FRANCK=("F" "R" "A" "N" "C" "K")
for x in "${FRANCK[@]}" 
	do 
		openssl enc -sm4-cbc -d -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $CLE
		dd if=${FILEPATH}.enc of=$FILEPATH status=none
		rm ${FILEPATH}.enc
		X=1
		until [[ $X -gt 2 ]] 
			do
				openssl enc -des-ede3-cbc -d -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $CLE
				dd if=${FILEPATH}.enc of=$FILEPATH status=none
				rm ${FILEPATH}.enc
				openssl enc -camellia-256-cbc -d -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $CLE
				dd if=${FILEPATH}.enc of=$FILEPATH status=none
				rm ${FILEPATH}.enc
				((X++))
			done
		openssl enc -aes-256-cbc -d -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $CLE
		dd if=${FILEPATH}.enc of=$FILEPATH status=none
		rm ${FILEPATH}.enc
	done
echo ""
echo "........................................."
echo "....Déchiffrement du fichier effectué...."
echo "........................................."
