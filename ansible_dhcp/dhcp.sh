#!/bin/bash
ROOT_UID=0
ERR_NONROOT=13
ERR_NONEXT=2

loading() {
  local FRAMES="/ | \ -"
  for FRAME in ${FRAMES}
  do
    printf "\r%s Loading..." "${FRAME}"
    sleep 0.5
  done
}

if [[ ${ROOT_UID} = "${UID}" ]]
then
  echo "You must be not root to execute this script. Aborting." >&2
  exit "${ERR_NONROOT}"
fi

if [[ ! -f "${PWD}/hosts" ]]
then
  echo "Cannot find 'hosts'. Create this file first." >&2
  exit "${ERR_NONEXT}"
fi

 if [[ ! -f "${PWD}/templates/isc-hdcp-server.tmpl" ]] && [[ ! -f "${PWD}/templates/dhcpd.conf.tmpl" ]]
then
  echo "Cannot find template configs. Reinstall script properly." >&2
  exit "${ERR_NONEXT}"
fi

while read -r -p "Choose ip of remote server: " SRV_NM
do
  if [[ -z "${SRV_NM}" ]]
  then
    continue
  else
    break 2
  fi
done

INV_STR=$(grep "${SRV_NM}" "${PWD}"/hosts) || {
  echo "Cannot find ${SRV_NM} in 'hosts'. Aboring." >&2
   exit "${ERR_NONEXT}"
}

for var in ${INV_STR}
  do
    case "${var}" in
      *=*)
        continue
      ;;
      *)
       ANS_HSTNM=${var}
      ;;
    esac
done

ANS_PING=$(ansible -m ping -i hosts "${ANS_HSTNM}")

while [[ -n "${ANS_PING}" ]]
  do
    loading
    case "${ANS_PING}" in
      *SUCCESS*)
        break 2
      ;;
      *UNREACHABLE*)
        printf "\n"
        echo "Ping ${ANS_HSTNM} failed. Host is unreachable." >&2
        exit "${ERR_NONEXT}"
      ;;
      *)
        continue
      ;;
    esac
  done
printf "\rPing %s successfully" "${ANS_HSTNM}"
printf "\n"

ANS_INT=$(ansible -m shell -a 'ip a' -i hosts "${ANS_HSTNM}" | tail -n +2 || true)
while [[ -n "${ANS_INT}" ]]
  do
    loading
    printf "\r%s" "${ANS_INT}"
    printf "\n"
    read -r -p "Choose interface for DHCP Server: " INT

    if [[ -z "${INT}" ]]
    then
      continue
    fi

    case "${ANS_INT}" in
      *"${INT}"*)
        echo "Found ${INT} in ${ANS_HSTNM}"
        break 2
        ;;
      *)
        continue
        ;;
    esac
    exit
  done

req_decl() {
  while read -r -p "Choose $1: " "$2"
  do
    if [[ -z "${!2}" ]]
    then
      continue
    else
      break 2
    fi
  done
}

req_decl "domain name" "DNAME"
req_decl "DNS server" "DNSSERV"
req_decl "subnet" "SUBNT"
req_decl "netmask [xxx.xxx.xxx.xxx]" "NTMSK"
req_decl "first address of this pool" "FSTADDR"
req_decl "last address of this pool" "LSTADDR"
req_decl "gateway" "GW"
