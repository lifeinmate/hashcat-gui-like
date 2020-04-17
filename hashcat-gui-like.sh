#!/bin/bash
cd

input (){
zenity --entry --text="Enter $1" --width=350
}

file_select (){
zenity --info --text="Select file with $1" --timeout=3 --width=180
}

display(){
zenity --info --text="$1" --timeout=3 --width=250
}

loader (){
zenity --progress --pulsate --text=$1 --timeout=2
}

file_display (){
tail $1 --lines=21 | head --lines=10 | zenity --text-info --title="RESULTS" --width="650" --height="300"
}

hashidentify (){
#sudo apt-get install git terminator python3 -y
#git clone https://github.com/blackploit/hash-identifier.git /opt
#chmod +x /opt/hash-identifier/hash-id.py
cd /opt/hash-identifier
hash=$( input hash)
#display $(pwd)
terminator -x python3 hash-id.py $hash
}

proc (){
file_select $1_file
f1=$(zenity --file-selection)
file_select wordlist
f2=$(zenity --file-selection)
hashcat -m $2 $f1 $f2 --force > /tmp/$1result.txt
loader CRACKING!!!
file_display /tmp/$1result.txt
}

#BODY
pick=$(zenity  --list  --text "Select Action" --radiolist --width=400 --height=400 --column "Pick" --column "q" FALSE 'Identify hash' \
FALSE 'I already know what type of hash it is' \
FALSE 'Decode base64' FALSE 'Encode base64' \
FALSE 'Create custom password comnbinations')

if [[ $pick == 'Decode base64' ]]
then display $(echo $(input 'base64 code') | base64 -d )
exit
elif [[ $pick == 'Encode base64' ]]
then display $(echo $(input 'text') | base64 )
exit
#include seperate form for encoding and decoding
elif [[ $pick == 'Identify hash' ]]
then hashidentify
elif [[ $pick == 'Create custom password combinations' ]]
then a=100

fi

choice=$(zenity  --list  --text "Hash mode known" --radiolist --width=300 --height=500 --column "Pick" --column "Hash Type" \
FALSE "MD5" FALSE 'SHA1' FALSE 'SHA1 with SALT' FALSE "SHA256" \
FALSE 'SHA512CRYPT' FALSE 'BCRYPT-BLOWFISH'  \
FALSE 'NTLM' FALSE 'LM' FALSE 'NT' \
FALSE 'OTHER')

if [[ $choice == 'MD5' ]]
then a=0
elif [[ $choice == 'SHA1' ]]
then a=100
elif [[ $choice == 'SHA256' ]]
then a=1400
elif [[ $choice == 'SHA512CRYPT' ]]
then a=1800
elif [[ $choice == 'BCRYPT-BLOWFISH' ]]
then a=3200
elif [[ $choice == 'SHA1 with SALT' ]]
then a=110
elif [[ $choice == 'NTLM' ]]
then a=1000
elif [[ $choice == 'OTHER' ]]
then display 'ERROR 404 : Under construction'
exit
else 
exit 
fi

proc $choice $a 
