

 
			PUBLICKEY=~/desktop/ClePublique.pem ;  \
		   	PATH="/usr/bin:/bin:/usr/sbin:/sbin:   \
		   	/dev:/opt/homebrew/Cellar/openssl@3/   \
		   	3.3.2/bin:";    		       \
  		   	echo "Quel est le chemin du fichier à" \
    		   	"chiffrer ?" ; read FILEPATH ; echo "";\
      		   	PWRDPATH=~/desktop/PWRD ; openssl rand \
		   	-out $PWRDPATH 500 ;	echo 	       \
		   	"................................" ;   \
	  	   	FRANCK=("F" "R" "A" "N" "C" "K") ; for \
	    	   	x in "${FRANCK[@]}" ; do openssl enc   \
	      	   	-aes-256-cbc -e -in $FILEPATH -out     \
		   	${FILEPATH}.enc -salt -pbkdf2 -kfile   \
		   	$PWRDPATH ; dd if=${FILEPATH}.enc      \
		   	of=$FILEPATH status=none ; rm	       \
		   	${FILEPATH}.enc;X=1;until [[ $X -gt 2  \
		   	]] ; do openssl enc -camellia-256-cbc  \
		   	-e -in $FILEPATH -out ${FILEPATH}.enc  \
		   	-salt -pbkdf2 -kfile $PWRDPATH ; dd    \
		   	if=${FILEPATH}.enc of=$FILEPATH	       \
		   	status=none;rm ${FILEPATH}.enc;openssl \
		   	enc -des-ede3-cbc -e -in $FILEPATH     \
		   	-out ${FILEPATH}.enc -salt -pbkdf2     \
		   	-kfile $PWRDPATH;dd if=${FILEPATH}.enc \
		   	of=$FILEPATH status=none ; ((X++)) ;   \
		   	rm ${FILEPATH}.enc ; done ; openssl enc\
		   	 -sm4-cbc -e -in $FILEPATH -out        \
		   	${FILEPATH}.enc -salt -pbkdf2 -kfile   \
		   	$PWRDPATH ; dd if=${FILEPATH}.enc      \
		   	of=$FILEPATH status=none ; rm          \
		   	${FILEPATH}.enc ; done ; echo "...."   \
		   	"Chiffrement du fichier ...." ;        \
		   	openssl pkeyutl -encrypt -pubin -inkey \
		   	$PUBLICKEY -in $PWRDPATH -out          \
		  	${PWRDPATH}.rsa ; dd if=${PWRDPATH}.rsa\
		   	 of=$PWRDPATH status=none ; rm         \
		   	${PWRDPATH}.rsa;echo ".... Chiffrement"\
		   	"de la clé ....." ; echo               \
		   	"................................"     \



