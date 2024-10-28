#!/bin/sh
# Un algorithme de chiffrement en cascade sous stéroides.

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
echo "Combien de fois voulez-vous le chiffrer ? "  
read N 
echo "Quel est le mot de passe de la database ? " 
read -s -r DBPWRD

FILE=${FILEPATH##*/}
FRANCK=("F" "R" "A" "N" "C" "K")

keepassxc-cli mkdir -y $YUBIKEY -k $KEYFILEPATH -q $DBPATH $FILE <<< $DBPWRD
i=1 
until [[ $i -gt $N ]]
	do
		keepassxc-cli add -y $YUBIKEY -k $KEYFILEPATH -q -g -L 999 -e -c ѮѰѠѪѦѬѨ $DBPATH $FILE/$i <<< $DBPWRD
		X=$(keepassxc-cli show -s -a password -y $YUBIKEY -k $KEYFILEPATH $DBPATH $FILE/$i <<< $DBPWRD)
		for x in "${FRANCK[@]}" 
			do 
				openssl enc -aes-256-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
				dd if=${FILEPATH}.enc of=$FILEPATH status=none
				rm ${FILEPATH}.enc
				for x in "${FRANCK[@]}" 
					do 
						openssl enc -camellia-256-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
						dd if=${FILEPATH}.enc of=$FILEPATH status=none
						rm ${FILEPATH}.enc
						openssl enc -des-ede3-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
						dd if=${FILEPATH}.enc of=$FILEPATH status=none
						rm ${FILEPATH}.enc
					done
				openssl enc -sm4-cbc -e -in $FILEPATH -out ${FILEPATH}.enc -salt -pbkdf2 -k $X
				dd if=${FILEPATH}.enc of=$FILEPATH status=none
				rm ${FILEPATH}.enc
			done
		echo "Chiffrement $i effectué"
		((i++))
	done
