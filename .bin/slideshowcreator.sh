#! /bin/bash

##################################
#	@author:mepowerleo10
#	@date:March 4th, 2019
#	1) The creator offers no guarantee for this work.
#	2) The creator won't be liable to any error or mis-operation of this software.
#	3) The duplication, modification, and redistribution of this work is allowed as long as section (1) & (2) above are adhered to.
##################################

FOLDER=$(realpath "$1")

if [ -e "$FOLDER" ] && [ -d "$FOLDER" ];then
	read -p "Name your slide [Enter for auto-naming]: " OUT
	if [ -z $OUT ];then
		OUT=$(date +%a_%d-%m-%Y_%H:%M:%S)-slideshow.xml
	else
		OUT=$OUT.xml
	fi

	cat /home/mepowerleo10/bin/initial-snippet.txt > $OUT
	IMAGES=($(ls "$FOLDER" | grep -E '.jpeg$|.jpg$|.png$' | sort -R))
	echo -e "\t\t<!-- The contents begin here! -->" >> $OUT
	
	for((i = 0; i < ${#IMAGES[@]}; i++))
	do
		echo -e "\t<static>\n\t\t<duration>895.0</duration>" >> $OUT
		echo -e "\t\t<file>$FOLDER/${IMAGES[$i]}</file>\n\t</static>" >> $OUT
		echo -e "\t<transition>\n\t\t<duration>5.0</duration>" >> $OUT
		echo -e "\t\t<from>$FOLDER/${IMAGES[$i]}</from>" >> $OUT
		if [ $i -lt $((${#IMAGES[@]} - 1)) ];then
			echo -e "\t\t<to>$FOLDER/${IMAGES[$(($i+1))]}</to>\n\t</transition>" >> $OUT
		else
			echo -e "\t\t<to>$FOLDER/${IMAGES[0]}</to>\n\t</transition>" >> $OUT
		fi
	done
	echo '</background>' >> $OUT
	mv $OUT $FOLDER
	
	echo -e "\nYour slideshow background has been generated\n"
	
	read -p "Do you want to set the background now? [Y/n]: " choice
	if [[ $(echo $choice | tr a-z A-Z) == Y ]];then
		dconf write "/org/gnome/desktop/background/picture-uri" "'file://$FOLDER/$OUT'"
	fi
	exit 0
	
elif [ ! -e "$FOLDER" ];then
	echo -e "\nThe folder \e[31m$FOLDER \e[0mdoesn't exist\n"
	exit 1
	
elif [ ! -d "$FOLDER" ];then
	echo -e "\n\e[31m$FOLDER \e[0mmust be a folder!\n"
	exit 1
fi
