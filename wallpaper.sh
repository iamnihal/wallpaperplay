#!/bin/bash
clear
logo()
{
    cat << "EOF"
	  __          __   _ _                                   _
	  \ \        / /  | | |                                 | |
	   \ \  /\  / /_ _| | |_ __   __ _ _ __   ___ _ __ _ __ | | __ _ _   _
	    \ \/  \/ / _` | | | '_ \ / _` | '_ \ / _ \ '__| '_ \| |/ _` | | | |
	     \  /\  / (_| | | | |_) | (_| | |_) |  __/ |  | |_) | | (_| | |_| |
	      \/  \/ \__,_|_|_| .__/ \__,_| .__/ \___|_|  | .__/|_|\__,_|\__, |
	                      | |         | |             | |             __/ |
	                      |_|         |_|             |_|            |___/

EOF
         }
         clear
         logo
         wget $1
         if [ "$?" -eq 0 ]
         then
             echo "URL is OK"
             filename=$(echo "$1" | grep -Eoi 'board/.*' | cut -d'/' -f2)
             cat "$filename" | grep -Eoi '<a[^>]+>' | grep -Eoi '/.*jpg' | sed 's/^/https:\/\/www.wallpaperplay.com/g' > links.txt
             wget $2 $3 -i links.txt -P wallpapers/
             rm $filename
             rm links.txt
         else
             echo -e "\e[31mSomething is wrong with URL :(\e[0m]"
             exit
         fi
