#!/bin/sh
# Un algorithme de chiffrement sous stéroides.

##########
# Set Up #
##########

KEYFILEPATH=/Volumes/FichierClé/Clé_Chiffre_DB.keyx
YUBIKEY=2:19927424
DBPATH=/Users/mathis/Documents/Informatique/Shell/Chiffre.kdbx
FILEPATH=/Users/mathis/Desktop/test2.txt

########
# PATH #
########

PATH=/usr/bin:/bin:/usr/sbin:/sbin:/dev:/Applications/KeePassXC.app/contents/MacOS:/opt/homebrew/bin:/opt/homebrew/Cellar/openssl@3/3.3.2/bin: 

########
# Code #
########

echo "Combien de fois voulez-vous le chiffrer ? "  
read N 
echo "Quel est le mot de passe de la database ? " 
read -s -r DBPWRD

FILE=${FILEPATH##*/}
echo $DBPWRD | keepassxc-cli mkdir -y $YUBIKEY -k $KEYFILEPATH -q $DBPATH $FILE
i=1 
until [[ $i -gt $N ]]
	do
		echo $DBPWRD | keepassxc-cli add -y $YUBIKEY -k $KEYFILEPATH -q -g -L 999 -e -c ѮѰѠѪѦѬѨ $DBPATH $FILE/$i
		X=$(echo $DBPWRD | keepassxc-cli show -s -a password -y $YUBIKEY -k $KEYFILEPATH $DBPATH $FILE/$i)
		openssl enc -aes-256-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
		dd if=${FILEPATH}.enc of=$FILEPATH status=none
		rm ${FILEPATH}.enc
		openssl enc -camellia-256-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
		dd if=${FILEPATH}.enc of=$FILEPATH status=none
		rm ${FILEPATH}.enc
		openssl enc -des-ede3-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
		dd if=${FILEPATH}.enc of=$FILEPATH status=none
		rm ${FILEPATH}.enc
		openssl enc -sm4-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
		dd if=${FILEPATH}.enc of=$FILEPATH status=none
		rm ${FILEPATH}.enc
		echo "Chiffrement $i effectué"
		((i++))
	done
