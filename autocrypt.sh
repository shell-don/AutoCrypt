#!/bin/sh

#=================== DESCRIPTION ====================#
#                                                    #
# autocrypt automatically encrypts files multiple    #
# times.                                             #
# It generates strong, unique passwords using        #
# keepassxc-cli (~13 000 bit of entropy) and         #
# performs encryption with OpenSSL.                  #
#                                                    #
# By combining multiple authentication factors,      #
# autocrypt transforms digital risk into physical    #
# risk: if any required authentication factor is     #
# missing (Yubikey, Keyfile or Database), the data   #
# becomes impossible to decrypt.                     #
#                                                    #
#====================== USAGE =======================#
#                                                    #
# ./autocrypt.sh [-h | --help]                       #
#                                                    #
#================== DEPENDENCIES ====================#
#                                                    #
# openssl, keepassxc-cli, dd (status=none)           #
#                                                    #
#=================== INFORMATION ====================#
#                                                    #
# Author : Pigassou Mathis                           #
# Version : 0.1.1                                    #
# Last realease : 22/12/2025                         #
# POSIX : yes                                        #
#                                                    #
#====================== SET UP ======================#

readonly KEYFILEPATH="your_key_file_path"
readonly YUBIKEY=slot:serial
readonly DBPATH="your_database_path"
readonly DBPWRD="your_database_password"
N=3

#===================== CODE =========================#

KERNEL_NAME="$(uname -s)"

case "${KERNEL_NAME}" in

	Linux)

	PATH="/usr/bin:/bin"
	;;

	Darwin)

	PATH="/usr/bin:/bin:/Applications/KeePassXC.app/contents/MacOS"
	;;

	*)
	printf 'Error : %s kernel is not recognize\n' "${KERNEL_NAME}"
	exit 1
	;;

esac

MODE="$1"
ALGO="$2"

if [ "${#}" -ge 2 ] ; then
	shift 2
elif [ "${#}" -eq 1 ] ; then
	shift 1
fi

show_help() {

	printf "Usage :\n\nautocrypt [mode] [algorithm] file1 file2 ...\n\nMode :\n\n	-e : encrypt mode\n	-d : decrypt mode\n	-s : erase mode using encryption\n	-h : show help\n\nCipher algorithm :\n\n	-aes-128-cbc               -aes-128-cfb               -aes-128-cfb1
	-aes-128-cfb8              -aes-128-ctr               -aes-128-ecb
	-aes-128-ofb               -aes-192-cbc               -aes-192-cfb
	-aes-192-cfb1              -aes-192-cfb8              -aes-192-ctr
	-aes-192-ecb               -aes-192-ofb               -aes-256-cbc
	-aes-256-cfb               -aes-256-cfb1              -aes-256-cfb8
	-aes-256-ctr               -aes-256-ecb               -aes-256-ofb
	-aes128                    -aes128-wrap               -aes128-wrap-pad
	-aes192                    -aes192-wrap               -aes192-wrap-pad
	-aes256                    -aes256-wrap               -aes256-wrap-pad
	-id-aes128-wrap            -id-aes128-wrap-pad        -id-aes192-wrap
	-id-aes192-wrap-pad        -id-aes256-wrap            -id-aes256-wrap-pad
	-aria-128-cbc              -aria-128-cfb              -aria-128-cfb1
	-aria-128-cfb8             -aria-128-ctr              -aria-128-ecb
	-aria-128-ofb              -aria-192-cbc              -aria-192-cfb
	-aria-192-cfb1             -aria-192-cfb8             -aria-192-ctr
	-aria-192-ecb              -aria-192-ofb              -aria-256-cbc
	-aria-256-cfb              -aria-256-cfb1             -aria-256-cfb8
	-aria-256-ctr              -aria-256-ecb              -aria-256-ofb
	-aria128                   -aria192                   -aria256
	-camellia-128-cbc          -camellia-128-cfb          -camellia-128-cfb1
	-camellia-128-cfb8         -camellia-128-ctr          -camellia-128-ecb
	-camellia-128-ofb          -camellia-192-cbc          -camellia-192-cfb
	-camellia-192-cfb1         -camellia-192-cfb8         -camellia-192-ctr
	-camellia-192-ecb          -camellia-192-ofb          -camellia-256-cbc
	-camellia-256-cfb          -camellia-256-cfb1         -camellia-256-cfb8
	-camellia-256-ctr          -camellia-256-ecb          -camellia-256-ofb
	-camellia128               -camellia192               -camellia256
	-franck                    -lucie\n\nOrder for options matter\n"
}



case "${MODE}" in

	-e)

	case "${ALGO}" in

		-aes-128-cbc | -aes-128-cfb | -aes-128-cfb1 | -aes-128-cfb8 | -aes-128-ctr | -aes-128-ecb | -aes-128-ofb | -aes-192-cbc | -aes-192-cfb |  -aes-192-cfb1 | -aes-192-cfb8 | -aes-192-ctr | -aes-192-ecb | -aes-192-ofb | -aes-256-cbc | -aes-256-cfb | -aes-256-cfb1 | -aes-256-cfb8 | -aes-256-ctr | -aes-256-ecb | -aes-256-ofb | -aes128 | -aes128-wrap | -aes128-wrap-pad | -aes192 | -aes192-wrap | -aes192-wrap-pad | -aes256 | -aes256-wrap | -aes256-wrap-pad | -id-aes128-wrap | -id-aes128-wrap-pad | -id-aes192-wrap | -id-aes192-wrap-pad | -id-aes256-wrap | -id-aes256-wrap-pad | -aria-128-cbc | -aria-128-cfb | -aria-128-cfb1 | -aria-128-cfb8 | -aria-128-ctr | -aria-128-ecb | -aria-128-ofb | -aria-192-cbc | -aria-192-cfb | -aria-192-cfb1 | -aria-192-cfb8 | -aria-192-ctr | -aria-192-ecb | -aria-192-ofb | -aria-256-cbc | -aria-256-cfb | -aria-256-cfb1 | -aria-256-cfb8 | -aria-256-ctr | -aria-256-ecb | -aria-256-ofb | -aria128 | -aria192 | -aria256 | -camellia-128-cbc | -camellia-128-cfb | -camellia-128-cfb1 | -camellia-128-cfb8 | -camellia-128-ctr | -camellia-128-ecb | -camellia-128-ofb | -camellia-192-cbc | -camellia-192-cfb | -camellia-192-cfb1 | -camellia-192-cfb8 | -camellia-192-ctr | -camellia-192-ecb | -camellia-192-ofb | -camellia-256-cbc | -camellia-256-cfb | -camellia-256-cfb1 | -camellia-256-cfb8 | -camellia-256-ctr | -camellia-256-ecb | -camellia-256-ofb | -camellia128 | -camellia192 | -camellia256)


		for FILEPATH in "$@"; do
    			if [ -e "${FILEPATH}" ]; then
        			FILE=${FILEPATH##*/}
				printf '%s' "${DBPWRD}" | keepassxc-cli mkdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q "${DBPATH}" "${FILE}"
				i=1
				until [ "${i}" -gt "${N}" ]
				do
					printf '%s' "${DBPWRD}" | keepassxc-cli add -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q -g -L 999 -e -c "ѮѰѠѪѦѬѨ" "${DBPATH}" "${FILE}/${i}"
					X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}/${i}")
					openssl enc "${ALGO}" -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
					dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
					rm "${FILEPATH}.enc"
					printf '%s encryption done\n' "${i}"
					i=$((i + 1))
				done
    			else
        			printf 'Error : %s does not exist\n' "${FILEPATH}"
				exit 1
    			fi
		done
		exit 0
		;;


		-franck)

		for FILEPATH in "$@"; do
    			if [ -e "${FILEPATH}" ]; then
        			FILE=${FILEPATH##*/}
				printf '%s' "${DBPWRD}" | keepassxc-cli mkdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q "${DBPATH}" "${FILE}"
				i=1
				until [ "${i}" -gt "${N}" ]
				do
					printf '%s' "${DBPWRD}" | keepassxc-cli add -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q -g -L 999 -e -c "ѮѰѠѪѦѬѨ" "${DBPATH}" "${FILE}/${i}"
					X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}/${i}")
					for _ in 1 2 3 4 5 6
					do
						openssl enc -aes-256-cbc -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						for __ in 1 2 3 4 5 6
						do
							openssl enc -camellia-256-cbc -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
							dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
							rm "${FILEPATH}.enc"
							openssl enc -aria-256-ecb -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
							dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
							rm "${FILEPATH}.enc"
						done
						openssl enc -sm4-cbc -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
					done
					printf '%s encryption done\n' "${i}"
					i=$((i + 1))
				done
    			else
        			printf 'Error : %s does not exist\n' "${FILEPATH}"
				exit 1
    			fi
		done
		exit 0
		;;


		-lucie)

		for FILEPATH in "$@"; do
    			if [ -e "${FILEPATH}" ]; then
        			FILE=${FILEPATH##*/}
				printf '%s' "${DBPWRD}" | keepassxc-cli mkdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q "${DBPATH}" "${FILE}"
				i=1
				until [ "${i}" -gt "${N}" ]
				do
					printf '%s' "${DBPWRD}" | keepassxc-cli add -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q -g -L 999 -e -c "ѮѰѠѪѦѬѨ" "${DBPATH}" "${FILE}/${i}"
					X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}/${i}")
					j=1
					until [ "${j}" -gt 2 ]
					do
						openssl enc -aes-256-cbc -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						openssl enc -camellia-256-cbc -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						openssl enc -aria-256-ecb -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						j=$((j + 1))
					done
					printf '%s encryption done\n' "${i}"
					i=$((i + 1))
				done
    			else
        			printf 'Error : %s does not exist\n' "${FILEPATH}"
				exit 1
    			fi
		done
		exit 0
		;;

		-h | --help)

		show_help
		exit 0
		;;

		*)

		printf 'Cipher algorithm %s not supported\n' "${ALGO}"
		printf "Show -h for help\n"
		exit 1
   		;;

	esac
   	;;

   	-d)

	case "${ALGO}" in

		-aes-128-cbc | -aes-128-cfb | -aes-128-cfb1 | -aes-128-cfb8 | -aes-128-ctr | -aes-128-ecb | -aes-128-ofb | -aes-192-cbc | -aes-192-cfb |  -aes-192-cfb1 | -aes-192-cfb8 | -aes-192-ctr | -aes-192-ecb | -aes-192-ofb | -aes-256-cbc | -aes-256-cfb | -aes-256-cfb1 | -aes-256-cfb8 | -aes-256-ctr | -aes-256-ecb | -aes-256-ofb | -aes128 | -aes128-wrap | -aes128-wrap-pad | -aes192 | -aes192-wrap | -aes192-wrap-pad | -aes256 | -aes256-wrap | -aes256-wrap-pad | -id-aes128-wrap | -id-aes128-wrap-pad | -id-aes192-wrap | -id-aes192-wrap-pad | -id-aes256-wrap | -id-aes256-wrap-pad | -aria-128-cbc | -aria-128-cfb | -aria-128-cfb1 | -aria-128-cfb8 | -aria-128-ctr | -aria-128-ecb | -aria-128-ofb | -aria-192-cbc | -aria-192-cfb | -aria-192-cfb1 | -aria-192-cfb8 | -aria-192-ctr | -aria-192-ecb | -aria-192-ofb | -aria-256-cbc | -aria-256-cfb | -aria-256-cfb1 | -aria-256-cfb8 | -aria-256-ctr | -aria-256-ecb | -aria-256-ofb | -aria128 | -aria192 | -aria256 | -camellia-128-cbc | -camellia-128-cfb | -camellia-128-cfb1 | -camellia-128-cfb8 | -camellia-128-ctr | -camellia-128-ecb | -camellia-128-ofb | -camellia-192-cbc | -camellia-192-cfb | -camellia-192-cfb1 | -camellia-192-cfb8 | -camellia-192-ctr | -camellia-192-ecb | -camellia-192-ofb | -camellia-256-cbc | -camellia-256-cfb | -camellia-256-cfb1 | -camellia-256-cfb8 | -camellia-256-ctr | -camellia-256-ecb | -camellia-256-ofb | -camellia128 | -camellia192 | -camellia256)

		for FILEPATH in "$@"; do
    			if [ -e "${FILEPATH}" ]; then
        			FILE=${FILEPATH##*/}
				i=1
				until [ "${N}" -lt "${i}" ]
				do
					X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"/"${N}")
					openssl enc "${ALGO}" -d -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
					dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
					rm "${FILEPATH}.enc"
					printf 'Decryption %s done\n' "${N}"
					N=$((N - 1))
				done
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" Corbeille
    			else
        			printf 'Error : %s does not exist\n' "${FILEPATH}"
				exit 1
    			fi
			N=3
		done
		exit 0
		;;


		-franck)

		for FILEPATH in "$@"; do
    			if [ -e "${FILEPATH}" ]; then
        			FILE=${FILEPATH##*/}
				i=1
				until [ "${N}" -lt "${i}" ]
				do

					X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"/"${N}")
					for _ in 1 2 3 4 5 6
					do
						openssl enc -sm4-cbc -d -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						for __ in 1 2 3 4 5 6
						do
							openssl enc -aria-256-ecb -d -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
							dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
							rm "${FILEPATH}.enc"
							openssl enc -camellia-256-cbc -d -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
							dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
							rm "${FILEPATH}.enc"
						done
						openssl enc -aes-256-cbc -d -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
					done
					printf 'Decryption %s done\n' "${N}"
					N=$((N - 1))
				done

				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" Corbeille
    			else
        			printf 'Error : %s does not exist\n' "${FILEPATH}"
				exit 1
    			fi
			N=3
		done
		exit 0
		;;

		-lucie)

		for FILEPATH in "$@"; do
    			if [ -e "${FILEPATH}" ]; then
        			FILE=${FILEPATH##*/}
				i=1
				until [ "${N}" -lt "${i}" ]
				do
					X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"/"${N}")
					j=1
					until [ "${j}" -gt 2 ]
					do
						openssl enc -aria-256-ecb -d -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						openssl enc -camellia-256-cbc -d -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						openssl enc -aes-256-cbc -d -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						j=$((j + 1))
					done
					printf 'Decryption %s done\n' "${N}"
					N=$((N - 1))
				done
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" Corbeille
    			else
        			printf 'Error : %s does not exist\n' "${FILEPATH}"
				exit 1
    			fi
			N=3
		done
		;;

		-h | --help)

		show_help
		exit 0
		;;

		*)

		printf 'Cipher algorithm %s not supported\n' "${ALGO}"
		printf "Show -h for help\n"
		exit 1
   		;;

	esac
	;;

	-s)

	case "${ALGO}" in

		-aes-128-cbc | -aes-128-cfb | -aes-128-cfb1 | -aes-128-cfb8 | -aes-128-ctr | -aes-128-ecb | -aes-128-ofb | -aes-192-cbc | -aes-192-cfb |  -aes-192-cfb1 | -aes-192-cfb8 | -aes-192-ctr | -aes-192-ecb | -aes-192-ofb | -aes-256-cbc | -aes-256-cfb | -aes-256-cfb1 | -aes-256-cfb8 | -aes-256-ctr | -aes-256-ecb | -aes-256-ofb | -aes128 | -aes128-wrap | -aes128-wrap-pad | -aes192 | -aes192-wrap | -aes192-wrap-pad | -aes256 | -aes256-wrap | -aes256-wrap-pad | -id-aes128-wrap | -id-aes128-wrap-pad | -id-aes192-wrap | -id-aes192-wrap-pad | -id-aes256-wrap | -id-aes256-wrap-pad | -aria-128-cbc | -aria-128-cfb | -aria-128-cfb1 | -aria-128-cfb8 | -aria-128-ctr | -aria-128-ecb | -aria-128-ofb | -aria-192-cbc | -aria-192-cfb | -aria-192-cfb1 | -aria-192-cfb8 | -aria-192-ctr | -aria-192-ecb | -aria-192-ofb | -aria-256-cbc | -aria-256-cfb | -aria-256-cfb1 | -aria-256-cfb8 | -aria-256-ctr | -aria-256-ecb | -aria-256-ofb | -aria128 | -aria192 | -aria256 | -camellia-128-cbc | -camellia-128-cfb | -camellia-128-cfb1 | -camellia-128-cfb8 | -camellia-128-ctr | -camellia-128-ecb | -camellia-128-ofb | -camellia-192-cbc | -camellia-192-cfb | -camellia-192-cfb1 | -camellia-192-cfb8 | -camellia-192-ctr | -camellia-192-ecb | -camellia-192-ofb | -camellia-256-cbc | -camellia-256-cfb | -camellia-256-cfb1 | -camellia-256-cfb8 | -camellia-256-ctr | -camellia-256-ecb | -camellia-256-ofb | -camellia128 | -camellia192 | -camellia256)

		for FILEPATH in "$@"; do
    			if [ -e "${FILEPATH}" ]; then
        			FILE=${FILEPATH##*/}
				printf '%s' "${DBPWRD}" | keepassxc-cli mkdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q "${DBPATH}" "${FILE}"
				i=1
				until [ "${i}" -gt "${N}" ]
				do
					printf '%s' "${DBPWRD}" | keepassxc-cli add -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q -g -L 999 -e -c "ѮѰѠѪѦѬѨ" "${DBPATH}" "${FILE}/${i}"
					X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}/${i}")
					openssl enc "${ALGO}" -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
					dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
					rm "${FILEPATH}.enc"
					printf '%s encryption done\n' "${i}"
					i=$((i + 1))
				done
				rm "${FILEPATH}"
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" Corbeille
				printf '%s successfully erased\n' "${FILE}"
    			else
        			printf 'Error : %s does not exist\n' "${FILEPATH}"
				exit 1
    			fi
		done
		exit 0
		;;


		-franck)

		for FILEPATH in "$@"; do
    			if [ -e "${FILEPATH}" ]; then
        			FILE=${FILEPATH##*/}
				printf '%s' "${DBPWRD}" | keepassxc-cli mkdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q "${DBPATH}" "${FILE}"
				i=1
				until [ "${i}" -gt "${N}" ]
				do
					printf '%s' "${DBPWRD}" | keepassxc-cli add -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q -g -L 999 -e -c "ѮѰѠѪѦѬѨ" "${DBPATH}" "${FILE}/${i}"
					X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}/${i}")
					for _ in 1 2 3 4 5 6
					do
						openssl enc -aes-256-cbc -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						for __ in 1 2 3 4 5 6
						do
							openssl enc -camellia-256-cbc -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
							dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
							rm "${FILEPATH}.enc"
							openssl enc -aria-256-ecb -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
							dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
							rm "${FILEPATH}.enc"
						done
						openssl enc -sm4-cbc -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
					done
					printf '%s encryption done\n' "${i}"
					i=$((i + 1))
				done
				rm "${FILEPATH}"
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" Corbeille
				printf '%s successfully erased\n' "${FILE}"
    			else
        			printf 'Error : %s does not exist\n' "${FILEPATH}"
				exit 1
    			fi
		done
		exit 0
		;;


		-lucie)

		for FILEPATH in "$@"; do
    			if [ -e "${FILEPATH}" ]; then
        			FILE=${FILEPATH##*/}
				printf '%s' "${DBPWRD}" | keepassxc-cli mkdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q "${DBPATH}" "${FILE}"
				i=1
				until [ "${i}" -gt "${N}" ]
				do
					printf '%s' "${DBPWRD}" | keepassxc-cli add -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q -g -L 999 -e -c "ѮѰѠѪѦѬѨ" "${DBPATH}" "${FILE}/${i}"
					X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}/${i}")
					j=1
					until [ "${j}" -gt 2 ]
					do
						openssl enc -aes-256-cbc -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						openssl enc -camellia-256-cbc -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						openssl enc -aria-256-ecb -e -in "${FILEPATH}" -out "${FILEPATH}.enc" -salt -pbkdf2 -k "${X}"
						dd if="${FILEPATH}.enc" of="${FILEPATH}" status=none
						rm "${FILEPATH}.enc"
						j=$((j + 1))
					done
					printf '%s encryption done\n' "${i}"
					i=$((i + 1))
				done
				rm "${FILEPATH}"
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
				printf '%s' "${DBPWRD}" | keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" Corbeille
				printf '%s successfully erased\n' "${FILE}"
    			else
        			printf 'Error : %s does not exist\n' "${FILEPATH}"
				exit 1
    			fi
		done
		exit 0
		;;

		-h | --help)

		show_help
		exit 0
		;;

		*)

		printf 'Cipher algorithm %s not supported\n' "${ALGO}"
		printf "Show -h for help\n"
		exit 1
   		;;

	esac
   	;;

	-h | --help)

	show_help
	exit 0
   	;;

   	*)

	printf 'Mode %s is not processed\n' "${MODE}"
	printf "Show -h for help\n"
	exit 1
   	;;
esac