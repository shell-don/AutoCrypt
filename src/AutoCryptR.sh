#!/bin/sh

##########
# Set Up #
##########

KEYFILEPATH=<Key_File_path>
YUBIKEY=<slot[:serial]>
DBPATH=<DataBase_path>
FILEPATH=<File_to_decrypt_path>

########
# PATH #
########

PATH=/usr/bin:/bin:/usr/sbin:/sbin:/dev:/Applications/KeePassXC.app/contents/MacOS:/opt/homebrew/bin:/opt/homebrew/Cellar/openssl@3/3.3.2/bin: 

########
# Code #
########

echo "Combien de fois voulez-vous le déiffrer ? "  
read N 
echo "Quel est le mot de passe de la database ? "  
read -s -r DBPWRD

FILE=${FILEPATH##*/}
i=1 
until [[ $N -lt $i ]]
	do
		
		X=$(echo $DBPWRD | keepassxc-cli show -s -a password -y $YUBIKEY -k $KEYFILEPATH $DBPATH $FILE/$N)
		openssl enc -d -aes-256-cbc -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
		dd if=${FILEPATH}.enc of=$FILEPATH status=none
		rm ${FILEPATH}.enc
		echo "Déiffrement $N effectué"
		((N--))
	done

echo $DBPWRD | keepassxc-cli rmdir -y $YUBIKEY -k $KEYFILEPATH $DBPATH $FILE
echo $DBPWRD | keepassxc-cli rmdir -y $YUBIKEY -k $KEYFILEPATH $DBPATH Corbeille
