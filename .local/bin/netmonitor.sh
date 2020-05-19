#!/bin/bash
 
bandwidth() {
	net_type=$(nmcli device status | awk 'NR==2 {print $2}')
	net_state=$(nmcli device status | awk 'NR==2 {print $3}')
	net_device=$(nmcli device status | awk 'NR==2 {print $1}')
	label=" 0B/s  0B/s"

	if [[ "$net_state"=="connected" ]];then
		if [[ "$net_type" == "gsm" ]];then
			speed=($(vnstat -tr -i usb0 | awk 'NR==4,NR==5 {print $2$3}'))
			label="  ${speed[0]}  ${speed[1]}"
		elif [ "$net_type" = "wifi" ];then
			speed=($(vnstat -tr -i wlan0 | awk 'NR==4,NR==5 {print $2$3}'))
			label="  ${speed[0]}  ${speed[1]}"
		else
			speed=($(vnstat -tr -i eth0 | awk 'NR==4,NR==5 {print $2$3}'))
                        label="  ${speed[0]}  ${speed[1]}"
		fi
	fi
	label="$label"
	echo -e $label
}

netname() {
	net_name=$(nmcli device status | awk 'NR==2 {print $4}')
	label="$net_name"
	if [ ${#label} -gt 7 ];then
		label="${title:0:6}..."
	fi 
	echo -e $label
}

ip_addr() {
	ip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
	if [ ${#label} -gt 12 ];then
		label="${title:0:13}..."
	fi 
	if [ "${#ip}" -gt 0 ];then
		echo "$ip"
	else
		echo "..."
	fi
}

t=0

toggle() {
    t=$(((t + 1) % 2))
}


trap "toggle" USR1

while true; do
    if [ $t -eq 0 ]; then
        netname
    elif [ $t -eq 1 ]; then
	ip_addr
    else
        bandwidth
    fi
    sleep 1 & wait
done
