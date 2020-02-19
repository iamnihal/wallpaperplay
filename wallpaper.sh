#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
grn=$'\e[1;32m'
end=$'\e[0m'
DIR=$PWD/wallpaperplay
clear

printf """\033[1;32m

        ╦ ╦┌─┐┬  ┬  ┌─┐┌─┐┌─┐┌─┐┬─┐┌─┐┬  ┌─┐┬ ┬
        ║║║├─┤│  │  ├─┘├─┤├─┘├┤ ├┬┘├─┘│  ├─┤└┬┘
        ╚╩╝┴ ┴┴─┘┴─┘┴  ┴ ┴┴  └─┘┴└─┴  ┴─┘┴ ┴ ┴

\033[1;m"""

download()
{
    echo -e "\n${RED}[+] Downloading '$count' Wallpapers [+]${NC}"
    echo -e "${RED}-----------------------------------${NC}\n"
    i=1
    for url in $(echo "$links")
    do
        curl -sOL -# "$url"
        echo "$i) Done"
        i=$((i + 1))
    done
}

dirCheck()
{
    if [ -d "$DIR" ]
    then
        read -p "${grn}[+] 'wallpaperplay' directory already exist. Do you want to save these wallpapers to new Directory? (y/n)${end} " choice
        if [[ "$choice" == 'y' || "$choice" == 'Y' ]]
        then
            echo "Enter the Directory name:- "
            read dirName
            dirCheck
        elif [[ "$choice" == 'n' || "$choice" == 'N' ]]
        then
            cd $DIR
            download
        else
            echo "[-] You have entered a wrong choice."
        fi
    else
        mkdir "$dirName"
        cd $PWD/$dirName
        download
    fi
}

if [ ! -x "$(command -v curl)" ]
then
    echo "[-] This script requires wget. Exiting."
    exit 1
elif [ -z "$1" ]
then
    echo "[-] Usage: ./wallpaper.sh https://wallpaperplay.com/board/blue-car-wallpapers"
    exit 1
fi
echo "[+] Fetching HTML page and Extracting Link from it [+]"
SOURCE=$(curl -sL -# $1)
if [ "$?" -eq 0 ]
then
    echo -e "==> Extraction Completed\n"
    links=$(echo "$SOURCE" | grep -Eoi '<a[^>]+>' | grep -Eoi '/.*jpg' | sed 's/^/https:\/\/www.wallpaperplay.com/g')
    count=$(echo "$links" | wc -l)
    dirCheck
else
    echo -e "\e[31mSomething is wrong with URL :(\e[0m]"
    exit 1
fi
