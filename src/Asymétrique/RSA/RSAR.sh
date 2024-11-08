


			PRIVATEKEY=~/desktop/ClePrive.pem ;    \
			PATH="/usr/bin:/bin:/usr/sbin:/sbin:   \
			/dev:/opt/homebrew/Cellar/openssl@3/   \
			3.3.2/bin:";    		       \
			echo "Quel est le chemin du fichier à" \
			"déchiffrer ?";read FILEPATH ; echo    \
			"Quel est le chemin de PWRD (clé) ?" ; \
			read PWRDPATH ; echo "" ; echo	       \
			".................................." ; \
			openssl pkeyutl -decrypt  -inkey       \
			$PRIVATEKEY -in $PWRDPATH -out         \
			${PWRDPATH}.rsa;dd if=${PWRDPATH}.rsa  \
			of=$PWRDPATH status=none ; rm          \
			${PWRDPATH}.rsa ; echo                 \
			".... Déchiffrement de la clé ....." ; \
			FRANCK=("F" "R" "A" "N" "C" "K") ; for \
			x in "${FRANCK[@]}" ; do openssl enc   \
			-sm4-cbc -d -in $FILEPATH -out         \
			${FILEPATH}.enc -salt -pbkdf2 -kfile   \
			$PWRDPATH ; dd if=${FILEPATH}.enc      \
			of=$FILEPATH status=none ; rm          \
			${FILEPATH}.enc;X=1; until [[ $X -gt 2 \
			]]; do openssl enc -des-ede3-cbc       \
			-d -in $FILEPATH -out ${FILEPATH}.enc  \
			-salt -pbkdf2 -kfile $PWRDPATH ; dd    \
			if=${FILEPATH}.enc of=$FILEPATH	       \
			status=none;rm ${FILEPATH}.enc;openssl \
			enc -camellia-256-cbc -d -in $FILEPATH \
			-out ${FILEPATH}.enc -salt -pbkdf2     \
			-kfile $PWRDPATH;dd if=${FILEPATH}.enc \
			of=$FILEPATH status=none ; ((X++)) ;   \
			rm ${FILEPATH}.enc ; done; openssl enc \
			-aes-256-cbc -d -in $FILEPATH -out     \
			${FILEPATH}.enc -salt -pbkdf2 -kfile   \
			$PWRDPATH ; dd if=${FILEPATH}.enc      \
			of=$FILEPATH status=none ; rm          \
			${FILEPATH}.enc ; done ; echo "...."   \
			"Déchiffrement du fichier ...." ;      \
			rm $PWRDPATH ; echo                    \
			".................................."   \
