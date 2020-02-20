#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
grn=$'\e[1;32m'
end=$'\e[0m'
DIR=$PWD/$filename
URL="$1"
filename=$(echo "$URL" | grep -Eoi 'board/.*' | cut -d'/' -f2)
clear

printf """\033[1;32m

    ╦ ╦┌─┐┬  ┬  ┌─┐┌─┐┌─┐┌─┐┬─┐┌─┐┬  ┌─┐┬ ┬
    ║║║├─┤│  │  ├─┘├─┤├─┘├┤ ├┬┘├─┘│  ├─┤└┬┘
    ╚╩╝┴ ┴┴─┘┴─┘┴  ┴ ┴┴  └─┘┴└─┴  ┴─┘┴ ┴ ┴

\033[1;m"""

download()
{
    echo "[+] Fetching HTML page and Extracting Link from it [+]"
    SOURCE=$(curl -sL -# $URL)
    if [ "$?" -eq 0 ]
    then
        echo -e "==> Extraction Completed\n"
        links=$(echo "$SOURCE" | grep -Eoi '<a[^>]+>' | grep -Eoi '/.*jpg' | sed 's/^/https:\/\/www.wallpaperplay.com/g')
        count=$(echo "$links" | wc -l)
        echo -e "\n${RED}[+] Downloading '$count' Wallpapers [+]${NC}"
        echo -e "${RED}-----------------------------------${NC}\n"
        i=1
        for url in $(echo "$links")
        do
            curl -sOL -# "$url"
            echo "$i) Done"
            i=$((i + 1))
        done
    else
        echo -e "\e[31mSomething is wrong with URL :(\e[0m]"
        exit 1
    fi
}

newDirCheck()
{
    echo "Enter the new Directory name:- "
    read dirName
    if [ -d "$dirName" ]
    then
        echo -e "${RED}[-] '$dirName' Directory already exist.${NC}\n"
        newDirCheck
    else
        mkdir $PWD/$dirName
        cd $PWD/$dirName
        download
    fi

}
dirCheck()
{
    if [ -d "$filename" ]
    then
        read -p "${grn}[+] '$filename' directory already exist. Do you want to save these wallpapers to new Directory? (y/n)${end} " choice
        if [[ "$choice" == 'y' || "$choice" == 'Y' ]]
        then
            newDirCheck
        elif [[ "$choice" == 'n' || "$choice" == 'N' ]]
        then
            cd $DIR
            download
        else
            echo "[-] You have entered a wrong choice."
        fi
    else
        mkdir "$PWD/$filename"
        cd "$PWD/$filename"
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
elif [ -d "$filename" ]
then
    echo "[-] You have already downloaded the photos of this category."
    read -p "${grn}Do you want to download it again? (y/N)${end} " choice1
    if [[ $choice1 == 'y' || $choice1 == 'Y' ]]
    then
        dirCheck
    elif [[ $choice1 == 'n' || $choice1 == 'N' ]]
    then
        echo -e "${RED}Good Bye.${NC}"
        exit 1
    fi
else
    dirCheck
fi
