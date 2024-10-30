#!/bin/sh

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

echo "Quel est le chemin du fichier à chiffrer ?"
read FILEPATH
echo "Quel est le mot de passe de la database ? " 
read -s -r DBPWRD
FILE=${FILEPATH##*/}
i=1
N=3
until [[ $N -lt $i ]]
	do
		X=$(keepassxc-cli show -s -a password -y $YUBIKEY -k $KEYFILEPATH $DBPATH $FILE/$N <<< $DBPWRD)
		x=1
		until [[ $x -gt 2 ]] 
			do
				openssl enc -des-ede3-cbc -d -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
				dd if=${FILEPATH}.enc of=$FILEPATH status=none
				rm ${FILEPATH}.enc
				openssl enc -camellia-256-cbc -d -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
				dd if=${FILEPATH}.enc of=$FILEPATH status=none
				rm ${FILEPATH}.enc
				openssl enc -aes-256-cbc -d -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
				dd if=${FILEPATH}.enc of=$FILEPATH status=none
				rm ${FILEPATH}.enc
				((x++))
			done
		echo "Déiffrement $N effectué"
		((N--))
	done

keepassxc-cli rmdir -y $YUBIKEY -k $KEYFILEPATH $DBPATH $FILE <<< $DBPWRD
keepassxc-cli rmdir -y $YUBIKEY -k $KEYFILEPATH $DBPATH Corbeille <<< $DBPWRD
