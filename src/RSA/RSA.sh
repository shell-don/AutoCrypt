# !/bin/sh
# Autaumatisation du chiffrement d'un fichier grâce à RSA
# pré-requis : avoir une clé publique
# J'ai privilégié la sécurité sur l'efficacité pour le chiffrement. 100Mo = 40s

##########
# Se† Up #
##########

PUBLICKEY=<Public_key_path>

########
# Pa†H # 
########

PATH=/usr/bin:/bin:/usr/sbin:/sbin:/dev:/opt/homebrew/bin:/opt/homebrew/Cellar/openssl@3/3.3.2/bin:

########
# Co∂e #
########

echo "Quel est le chemin du fichier à chiffrer ?"
read FILEPATH
PWRDPATH=~/desktop/PWRD

# générations d'une clé d'environ 6000 d'entropie (limité par RSA)
openssl rand -out $PWRDPATH 500

# chiffrement du fichier (symétrique en cascade)
FRANCK=("F" "R" "A" "N" "C" "K")
for x in "${FRANCK[@]}" 
	do 
		openssl enc -aes-256-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -kfile $PWRDPATH
		dd if=${FILEPATH}.enc of=$FILEPATH status=none
		rm ${FILEPATH}.enc
		X=1
		until [[ $X -gt 2 ]] 
			do
				openssl enc -camellia-256-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -kfile $PWRDPATH
				dd if=${FILEPATH}.enc of=$FILEPATH status=none
				rm ${FILEPATH}.enc
				openssl enc -des-ede3-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -kfile $PWRDPATH
				dd if=${FILEPATH}.enc of=$FILEPATH status=none
				rm ${FILEPATH}.enc
				((X++))
			done
		openssl enc -sm4-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -kfile $PWRDPATH
		dd if=${FILEPATH}.enc of=$FILEPATH status=none
		rm ${FILEPATH}.enc
	done
echo "Chiffrement du fichier effectué"

# chiffrement de la clé
openssl pkeyutl -encrypt -pubin -inkey $PUBLICKEY -in $PWRDPATH -out ${PWRDPATH}.rsa   
dd if=${PWRDPATH}.rsa of=$PWRDPATH status=none
rm ${PWRDPATH}.rsa
echo "Chiffrement de la clé effectué"
