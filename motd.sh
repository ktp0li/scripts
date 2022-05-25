#!/bin/sh
UPT=$(uptime | cut -d "l" -f1 | rev | cut -c4- | rev | cut -d " " -f4-)
#PROC=$(cut -d"/" -f2 /proc/loadavg | cut -d" " -f1)
PROC=$(ps ax | wc -l)
AVLD=$(cut -d " " -f1-3 /proc/loadavg)
USEDMEM=$(free | grep Mem | awk '{ print int(($3/$2 * 100.0) + 0.5) }')
USEDSWAP=$(free | grep Swap | awk '{ print int(($3/$2 * 100.0) + 0.5) }')
USEDSTRG=$(df / -h | tail -n 1 | awk '{print $3}')
USEDSTRGPERC=$(df / -h | tail -n 1 | awk '{print $5}')
STRG=$(df / -h | tail -n 1 | awk '{print $2}')

printf "\e[7mw e l c o m e\e[27m\n"
printf "\e[7mh o m e\e[27m\n"
printf "\e[2msystem load: ${AVLD}\tmemory usage: ${USEDMEM}%%\tprocesses: ${PROC}\n"
printf "usage of /: ${USEDSTRGPERC}% (${USEDSTRG}/${STRG})\tswap usage: ${USEDSWAP}%%\t\tuptime: ${UPT}\e[22m\n"
