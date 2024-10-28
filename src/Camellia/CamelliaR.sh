#!/bin/sh
# Algorithme d'automatisation (déchiffrement) de Camellia-256-CBC via une database kdbx à trois facteurs d'authentification

##########
# Se† Up #
##########

KEYFILEPATH=<Key_File_path>
YUBIKEY=<slot[:serial]>
DBPATH=<DataBase_path>

########
# Pa†H # 
########

PATH=/usr/bin:/bin:/usr/sbin:/sbin:/dev:/Applications/KeePassXC.app/contents/MacOS:/opt/homebrew/bin:/opt/homebrew/Cellar/openssl@3/3.3.2/bin: 

########
# Co∂e #
########

echo "Quel est le chemin du fichier à déchiffrer ?"
read FILEPATH
echo "Combien de fois voulez-vous le déchiffrer ? "  
read N 
echo "Quel est le mot de passe de la database ? "  
read -s -r DBPWRD

FILE=${FILEPATH##*/}
i=1 
until [[ $N -lt $i ]]
	do
		
		X=$(keepassxc-cli show -s -a password -y $YUBIKEY -k $KEYFILEPATH $DBPATH $FILE/$N <<< $DBPWRD)
		openssl enc -camellia-256-cbc -d -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
		dd if=${FILEPATH}.enc of=$FILEPATH status=none
		rm ${FILEPATH}.enc
		echo "Déiffrement $N effectué"
		((N--))
	done

keepassxc-cli rmdir -y $YUBIKEY -k $KEYFILEPATH $DBPATH $FILE <<< $DBPWRD
keepassxc-cli rmdir -y $YUBIKEY -k $KEYFILEPATH $DBPATH Corbeille <<< $DBPWRD
