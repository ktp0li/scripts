#!/bin/sh
SERVIP="192.168.1.113"
DEV="br0"
start () {
	iptables -t mangle -A PREROUTING -j ACCEPT -p tcp -m multiport --dports 80,443 -s "${SERVIP}"
	iptables -t mangle -A PREROUTING -j MARK --set-mark 3 -p tcp -m multiport --dports 80,443
	ip rule add fwmark 3 table 2
	ip route add default via "${SERVIP}" dev "${DEV}" table 2
}

stop () {
	iptables -t mangle -D PREROUTING -j ACCEPT -p tcp -m multiport --dports 80,443 -s "${SERVIP}"
	iptables -t mangle -D PREROUTING -j MARK --set-mark 3 -p tcp -m multiport --dports 80,443
	ip rule del fwmark 3 table 2
	ip route del default via "${SERVIP}" dev "${DEV}" table 2
}

case $1 in
	-u | up)
	start
	echo "proxy state is up"
	;;
	-d | down)
	stop
	echo "proxy state is down"
	;;
	*)
	echo "usage: ./dpi.sh [-u|up] or [-d|down]"
esac
