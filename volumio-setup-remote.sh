#!/bin/sh

# Help build a new volume of Volumio	
#
# run on remote machine after turning on the SSH server

# Download image from here:
# Echo - download the latest image
# open https://volumio.com/en/get-started/
#
# echo Burn image to flash card
#
# echo Boot machine - Join new WIFI network it creates. 
#
# Go through settings.

echo \n -- STARTING volumio-setup/volumio-setup-remote.sh --


if nc -zv volumio.local 22; then
    echo Port 22\(ssh\) is OPEN on volumio.local
else
    echo Port 22\(ssh\) is CLOSED on volumio.local
    echo Enable SSH in the browser at http://volumio.local/dev
    open http://volumio.local/dev
    exit
fi


if ssh -q volumio@volumio.local exit; then
        echo ssh login already works
    else 
        echo ssh login failed 

        echo removing existing volumio key from ~/.ssh/known_hosts
        ssh-keygen -f "/home/cooper/.ssh/known_hosts" -R "volumio.local"

        echo Create SSH keyless login:
        echo -- generate key
        ssh-keygen -t rsa -b 4096 -C "volumio-setup-remote.sh"
        echo -- copy key to volumio.local
        ssh-copy-id volumio@volumio.local
fi


echo -- Remove previous install of volumio-setup-local.sh
ssh volumio@volumio.local "test -e /tmp/volumio-setup-local.sh | rm /tmp/volumio-setup-local.sh;"

echo -- Copy volumio-setup-local.sh to volumio.local/tmp
scp ./volumio-setup-local.sh volumio@volumio.local:/tmp

echo -- Run volumio-setup-local.sh on volumio.local
ssh volumio@volumio.local "/tmp/volumio-setup-local.sh"

