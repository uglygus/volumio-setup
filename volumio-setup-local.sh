#!/bin/sh

# This will build a new volume of Volumio	
#


#Download image from here:
#Echo - download the latest image
#open https://volumio.com/en/get-started/


#echo Burn image to flash card


echo \n -- STARTING raspi-volumio-autplay/volumio-setup.sh --


if nc -zv volumio.local 22; then
    echo Port 22\(ssh\) is OPEN on volumio.local
else
    echo Port 22\(ssh\) is CLOSED on volumio.local
    #Enable SSH in here... 
    echo Enable SSH in the browser
    open http://volumio.local/dev
fi


if ssh -q volumio@volumio.local exit; then
        echo ssh login already works
    else 
        echo ssh login failed 

        echo removing existing volumio key from ~/.ssh/known_hosts
        ssh-keygen -f "/home/cooper/.ssh/known_hosts" -R "volumio.local"

        echo Create SSH keyless login:
        echo -- generate key
        ssh-keygen -t rsa -b 4096 -C "cooperbattersby@gmail.com"
        echo -- copy key to volumio.local
        ssh-copy-id volumio@volumio.local
fi

echo there!!!

# echo Create SSH keyless login:
# echo -- generate key
# ssh-keygen -t rsa -b 4096 -C "cooperbattersby@gmail.com"
# echo -- copy key to volumio.local
# ssh-copy-id volumio@volumio.local


# Burn image to flash card
#
#echo Boot machine - Join new WIFI network it creates. 
#
#Go through settings.




if ssh volumio@volumio.local "test -e /home/volumio/raspi-power-button"; then
    echo -- Remove previous install of volumio-autoplay
    ssh volumio@volumio.local '/home/volumio/raspi-power-button/uninstall.sh'
    ssh volumio@volumio.local 'rm -rf /home/volumio/raspi-power-button'
fi

if ssh volumio@volumio.local "test -e /home/volumio/volumio-autoplay"; then
    echo -- Uninstall volumio-autoplay
    ssh volumio@volumio.local '/home/volumio/raspi-volume-autoplay/uninstall.sh'
    echo -- Remove volumio-autoplay
    ssh volumio@volumio.local 'rm -rfq /home/volumio/raspi-volumio-autoplay'
fi

#From my laptop Copy Power-button over
echo -- Copying power-button to volumio@volumio.local
scp -r /Users/tbatters/DM-Shared/code/raspi-power-button  volumio@volumio.local:/home/volumio

#Copy auto-start
echo -- Copying volumio-autoplay to volumio@volumio.local
scp -r /Users/tbatters/DM-Shared/code/raspi-volumio-autoplay volumio@volumio.local:/home/volumio


#SSH into Volume
#ssh volumio@volumio.local

# To watch logs while installing you could open this in a new terminal
#journalctl -f

#Install pip3
if python3 -m pid; then
    echo -- INSTALLING pip
    ssh volumio@volumio.local 'sudo apt-get install -y python3-pip'
else
    echo pip is already installed!!
fi

echo -- apt-get autoremove
ssh volumio@volumio.local 'sudo apt-get -y autoremove'

echo -- Install Power Button
ssh -t volumio@volumio.local sudo /home/volumio/raspi-power-button/install.sh

echo -- Install Volumio-autoplay
ssh -t volumio@volumio.local sudo /home/volumio/raspi-volumio-autoplay/install.sh


