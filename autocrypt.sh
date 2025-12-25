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
# openssl, keepassxc-cli, shred                      #
#                                                    #
#=================== INFORMATION ====================#
#                                                    #
# Author : Pigassou Mathis                           #
# Version : 0.1.2                                    #
# Last realease : 25/12/2025                         #
# POSIX : yes                                        #
#                                                    #
#====================== SET UP ======================#

readonly KEYFILEPATH="your_key_file_path"
readonly YUBIKEY=slot:serial
readonly DBPATH="your_database_path"
readonly DBPWRD="your_database_password"
N=3

#===================== CODE =========================#

MODE=0
ALGO=0
VERBOSE=0
FILES=""

show_help() {

printf "Usage : autocrypt [mode] [algorithm] [-v|--verbose] file1 file2 ...

Mode :
	-e  --encrypt : encrypt mode
	-d  --decrypt : decrypt mode
	-s  --erase   : erase mode using encryption
	-h  --help    : show help

Cipher algorithm :

	-aes-256-ctr 	    -aes-256-ofb        -aes-192-ctr
	-aes-256-cbc 	    -aes-256-cfb 	-aes-256-cfb8
	-camellia-256-cbc	-camellia-256-cfb8\n"

}

KERNEL_NAME="$(uname -s)"

case "${KERNEL_NAME}" in

	Linux)

	PATH="/usr/bin:/bin"
	;;

	Darwin)

	PATH="/usr/bin:/bin:/opt/homebrew/bin:/Applications/KeePassXC.app/contents/MacOS"
	;;

	*)
	printf 'Error : %s kernel is not recognize\n' "${KERNEL_NAME}"
	exit 1
	;;

esac

parse_options() {

	while [ "${#}" -gt 0 ] ; do

		case "${1}" in

			-e | --encrypt)

			if [ "${MODE}" -eq 1 ] ; then
				printf '%s option can'\''t be used twice\n' "${1}"
				exit 1
			elif [ "${MODE}" -ne 0 ] ; then
				printf 'Mode is already defined use one mode\n'
				exit 1
			fi
			MODE=1
			case "${2}" in

				 -aes-256-ctr       \
				|-aes-256-ofb       \
				|-aes-256-cbc       \
				|-aes-256-cfb       \
				|-aes-256-cfb8      \
				|-aes-192-ctr       \
				|-camellia-256-cbc  \
				|-camellia-256-cfb8)

				if [ "${ALGO}" -ne 0 ] ; then
					printf 'Double cipher isn'\''t allowed\n'
					exit 1
				fi
				ALGO="${2}"
				shift 1
				;;

				*)

				printf '%s algorithm isn'\''t supported try [-h | --help]\n' "${2}"
				exit 1
            			;;

			esac
        		;;

        		-d | --decrypt)

			if [ "${MODE}" -eq 2 ] ; then
				printf '%s option can'\''t be used twice\n' "${1}"
				exit 1
			elif [ "${MODE}" -ne 0 ] ; then
				printf 'Mode is already defined use one mode\n'
				exit 1
			fi
			MODE=2
        		;;

			-s | --erase)

			if [ "${MODE}" -eq 3 ] ; then
				printf '%s option can'\''t be used twice\n' "${1}"
				exit 1
			elif [ "${MODE}" -ne 0 ] ; then
				printf 'Mode is already defined use one mode\n'
				exit 1
			fi
			MODE=3
			case "${2}" in

				 -aes-256-ctr       \
				|-aes-256-ofb       \
				|-aes-256-cbc       \
				|-aes-256-cfb       \
				|-aes-256-cfb8      \
				|-aes-192-ctr       \
				|-camellia-256-cbc  \
				|-camellia-256-cfb8)

				if [ "${ALGO}" -ne 0 ] ; then
					printf 'Double cipher isn'\''t allowed\n'
					exit 1
				fi
				ALGO="${2}"
				shift 1
				;;

				*)

				printf '%s algorithm isn'\''t supported try [-h | --help]\n' "${2}"
				exit 1
            			;;

			esac
        		;;

			-h | --help)

			if [ "${MODE}" -eq 4 ] ; then
				printf '%s option can'\''t be used twice\n' "${1}"
				exit 1
			elif [ "${MODE}" -ne 0 ] ; then
				printf 'Mode is already defined use one mode\n'
				exit 1
			fi
			MODE=4
        		;;

			-v | --verbose)

			if [ "${VERBOSE}" -ne 0 ] ; then
				printf '%s option can'\''t be used twice\n' "${1}"
				exit 1
			fi
			VERBOSE=1
        		;;

			-*)

			printf '%s is not an option try [-h | --help]\n' "${1}"
			exit 1
        		;;

			*)

			if ! [ -f "${1}" ] ; then
				printf '%s is not an existing file\n' "${1}"
				exit 1
			fi
			if [ -z "${FILES}" ]; then
    				FILES=$1
			else
    				FILES="${FILES}
${1}"
			fi
			;;

		esac
		shift 1
	done
	return 0
}

parse_options "${@}"

set -- $FILES

case "${MODE}" in

	1)

	if [ "${VERBOSE}" -eq 1 ] ; then
		for FILEPATH in "$@"; do
        		FILE=${FILEPATH##*/}
			printf '%s' "${DBPWRD}" | \
			keepassxc-cli mkdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" \
			 "${DBPATH}" "${FILE}"
			i=1
			until [ "${i}" -gt "${N}" ]
			do
				printf '%s' "${DBPWRD}" | \
				keepassxc-cli add -y "${YUBIKEY}" -k "${KEYFILEPATH}" \
				 -g -L 999 -e -c "ѮѰѠѪѦѬѨ" --notes "${ALGO#-}" "${DBPATH}" \
				 "${FILE}/${i}"
				X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a \
				password -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}/${i}")
				openssl enc -e "${ALGO}" -in "${FILEPATH}" -out "${FILEPATH}.enc" \
				-pbkdf2 -iter 33633 -salt -k "${X}"
				shred -fuzv --random-source=/dev/urandom "${FILEPATH}"
				mv -fn "${FILEPATH}.enc" "${FILEPATH}"
				printf '%s encryption done\n' "${i}"
				i=$((i + 1))
			done
		done
	else
		for FILEPATH in "$@"; do
        		FILE=${FILEPATH##*/}
			printf '%s' "${DBPWRD}" |\
			keepassxc-cli mkdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q "${DBPATH}" "${FILE}"
			i=1
			until [ "${i}" -gt "${N}" ]
			do
				printf '%s' "${DBPWRD}" | keepassxc-cli add -y "${YUBIKEY}" -k \
				"${KEYFILEPATH}" -q -g -L 999 -e -c "ѮѰѠѪѦѬѨ" --notes "${ALGO#-}" "${DBPATH}" "${FILE}/${i}"
				X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y \
				"${YUBIKEY}" -q -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}/${i}")
				openssl enc -e "${ALGO}" -in "${FILEPATH}" -out "${FILEPATH}.enc" \
				-pbkdf2 -iter 33633 -salt -k "${X}"
				shred -fuz --random-source=/dev/urandom "${FILEPATH}"
				mv -fn "${FILEPATH}.enc" "${FILEPATH}"
				printf '%s encryption done\n' "${i}"
				i=$((i + 1))
			done
		done
	fi
	exit 0
	;;

	2)

	if [ "${VERBOSE}" -eq 1 ] ; then
		for FILEPATH in "$@"; do
        		FILE=${FILEPATH##*/}
			i=1
			until [ "${N}" -lt "${i}" ]
			do
				X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y \
				"${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"/"${N}")
				ALGO_USED=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -a notes -y \
				"${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"/"${N}")
				openssl enc "-${ALGO_USED}" -d -in "${FILEPATH}" -out "${FILEPATH}.enc" \
				-pbkdf2 -iter 33633 -salt -k "${X}"
				shred -fuzv --random-source=/dev/urandom "${FILEPATH}"
				mv -fn "${FILEPATH}.enc" "${FILEPATH}"
				printf 'Decryption %s done\n' "${N}"
				N=$((N - 1))
			done
			printf '%s' "${DBPWRD}" | \
			keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
			printf '%s' "${DBPWRD}" | \
			keepassxc-cli rmdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" Corbeille
			N=3
		done
	else
		for FILEPATH in "$@"; do
        		FILE=${FILEPATH##*/}
			i=1
			until [ "${N}" -lt "${i}" ]
			do
				X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password -y \
				"${YUBIKEY}" -q -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"/"${N}")
				ALGO_USED=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -a notes -y \
				"${YUBIKEY}" -q -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"/"${N}")
				openssl enc "-${ALGO_USED}" -d -in "${FILEPATH}" -out "${FILEPATH}.enc" \
				-pbkdf2 -iter 33633 -salt -k "${X}"
				shred -fuz --random-source=/dev/urandom "${FILEPATH}"
				mv -fn "${FILEPATH}.enc" "${FILEPATH}"
				printf 'Decryption %s done\n' "${N}"
				N=$((N - 1))
			done
			printf '%s' "${DBPWRD}" | \
			keepassxc-cli rmdir -y "${YUBIKEY}" -q -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
			printf '%s' "${DBPWRD}" | \
			keepassxc-cli rmdir -y "${YUBIKEY}" -q -k "${KEYFILEPATH}" "${DBPATH}" Corbeille
			N=3
		done
	fi
	exit 0
	;;

	3)

	if [ "${VERBOSE}" -eq 1 ] ; then
		for FILEPATH in "$@"; do
        		FILE=${FILEPATH##*/}
			printf '%s' "${DBPWRD}" | keepassxc-cli mkdir -y "${YUBIKEY}" \
			-k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
			i=1
			until [ "${i}" -gt "${N}" ]
			do
				printf '%s' "${DBPWRD}" | \
				keepassxc-cli add -y "${YUBIKEY}" -k "${KEYFILEPATH}" \
				-g -L 999 -e -c "ѮѰѠѪѦѬѨ" "${DBPATH}" "${FILE}/${i}"
				X=$(printf '%s' "${DBPWRD}" | keepassxc-cli show -s -a password \
				-y "${YUBIKEY}" -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}/${i}")
				openssl enc -e "${ALGO}" -in "${FILEPATH}" -out "${FILEPATH}.enc" \
				-pbkdf2 -iter 33633 -salt -k "${X}"
				shred -fuzv --random-source=/dev/urandom "${FILEPATH}"
				mv -fn "${FILEPATH}.enc" "${FILEPATH}"
				printf '%s encryption done\n' "${i}"
				i=$((i + 1))
			done
			shred -fuzv --random-source=/dev/urandom "${FILEPATH}"
			printf '%s' "${DBPWRD}" | \
			keepassxc-cli rmdir -y "${YUBIKEY}" -q -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
			printf '%s' "${DBPWRD}" | \
			keepassxc-cli rmdir -y "${YUBIKEY}" -q -k "${KEYFILEPATH}" "${DBPATH}" Corbeille
			printf '%s successfully erased\n' "${FILE}"
		done
	else
		for FILEPATH in "$@"; do
        		FILE=${FILEPATH##*/}
			printf '%s' "${DBPWRD}" | \
			keepassxc-cli mkdir -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q "${DBPATH}" "${FILE}"
			i=1
			until [ "${i}" -gt "${N}" ]
			do
				printf '%s' "${DBPWRD}" | \
				keepassxc-cli add -y "${YUBIKEY}" -k "${KEYFILEPATH}" -q -g -L 999 \
				-e -c "ѮѰѠѪѦѬѨ" "${DBPATH}" "${FILE}/${i}"
				X=$(printf '%s' "${DBPWRD}" | \
				keepassxc-cli show -s -a password -y "${YUBIKEY}" -q -k \
				"${KEYFILEPATH}" "${DBPATH}" "${FILE}/${i}")
				openssl enc -e "${ALGO}" -in "${FILEPATH}" -out "${FILEPATH}.enc" \
				-pbkdf2 -iter 33633 -salt -k "${X}"
				shred -fuz --random-source=/dev/urandom "${FILEPATH}"
				mv -fn "${FILEPATH}.enc" "${FILEPATH}"
				printf '%s encryption done\n' "${i}"
				i=$((i + 1))
			done
			shred -fuz --random-source=/dev/urandom "${FILEPATH}"
			printf '%s' "${DBPWRD}" | \
			keepassxc-cli rmdir -y "${YUBIKEY}" -q -k "${KEYFILEPATH}" "${DBPATH}" "${FILE}"
			printf '%s' "${DBPWRD}" | \
			keepassxc-cli rmdir -y "${YUBIKEY}" -q -k "${KEYFILEPATH}" "${DBPATH}" Corbeille
			printf '%s successfully erased\n' "${FILE}"
		done
	fi
	exit 0
	;;

	4)

	show_help
	exit 0
	;;

	*)
	printf 'No mode used try [-h | --help]\n'
	exit 1
        ;;

esac
