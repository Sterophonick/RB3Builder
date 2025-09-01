#!/bin/bash

# we make this a variable because it is subject to change
RPCS3DIR="/run/media/deck/SteamDeckSD/EmulatorData/RPCS3/config/rpcs3/"

set -e

prompt() {
    kdialog --title "Steam Deck RB3 Instrument Selector" --radiolist "Select Controller in Port $1:" "ghg" "Xbox 360 Guitar Hero Guitar (Les Paul, World Tour, etc)" on "rbd" "Xbox 360 Rock Band Drums (Beatles, MIDI Pro, etc)" on "rbg" "Xbox 360 Rock Band Guitar (Stratocaster, Hofner, etc)" on "ghd" "Xbox 360 Guitar Hero Drums" on "voc" "Vocals" on "empty" "Empty Slot" on
    if [ $? -ne 0 ]; then
        echo Aborting Config Generation!
        wehhhhh # HACK: just terminate the thing lol
    fi
}

sedPorts() {
    local realPort=$(($1+1))
    local evdevPort=$1

    cp ./templates/$2.yml /tmp/instrument.yml

    echo Mapping Player $realPort to Xbox 360 Controller $evdevPort

    sed -i "s/Player X Input/Player $(echo $realPort) Input/" /tmp/instrument.yml
    sed -i "s/Microsoft X-Box 360 pad Y/Microsoft X-Box 360 pad $(echo $evdevPort)/" /tmp/instrument.yml

    cat /tmp/instrument.yml >> ./newConfig.yml
}

if [ -e "./newConfig.yml" ]; then
  rm ./newConfig.yml
fi

FILE=$(prompt 1)
sedPorts 0 $FILE

FILE=$(prompt 2)
sedPorts 1 $FILE

FILE=$(prompt 3)
sedPorts 2 $FILE

FILE=$(prompt 4)
sedPorts 3 $FILE

sedPorts 4 empty
sedPorts 5 empty
sedPorts 6 empty

cp ./newConfig.yml $RPCS3DIR/input_configs/BLUS30463/Default.yml
rm ./newConfig.yml
