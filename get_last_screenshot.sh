#!/usr/bin/env bash

OS=''
QUANTITY=1
VERBOSE="false"
SSH_ADDRESS=""
SSH_PORT="22"
SSH_USER="mobile"

while [[ $# -gt 0 ]]; do
    case $1 in
        android)
            OS="$1"
            shift
        ;;

        iOS|ios)
            OS="ios"
            shift
        ;;

        [0-9]*)
           QUANTITY=$1
           shift
        ;;

        -a|--address)
            SSH_ADDRESS="$2"
            shift 2
        ;;

        -p|--port)
            SSH_PORT="$2"
            shift 2
        ;;

        -u|--user)
            SSH_USER="$2"
            shift 2
        ;;

        -v|--verbose)
            VERBOSE="true"
            shift
        ;;
        
        -h|--help)
            echo "Usage..."
            exit
        ;;
        *)
            echo "Error: unknow option '$1'"
            exit
        ;;
    esac
done

# checking if params are valid
if [[ $OS == "" ]]; then
    echo "Error: select an OS first"
    exit
elif [[ $OS == "android" && $(adb devices | awk 'NR > 1 && NF && $NF == "device" {print $1}') == "" ]]; then
    echo 'Error: Connect your android via ADB first'
    exit
elif [[ $OS == "ios" && ( $SSH_ADDRESS == "") ]]; then
    echo 'Error: ios requires SSH address'
    exit
fi

$VERBOSE && echo "Info: I'll connect to the $OS at $SSH_ADDRESS to download $QUANTITY picture(s)..."

if [[ $OS == "android" ]]; then
    screenshot_path="/sdcard/Pictures/Screenshots/"
    adb shell ls -t $screenshot_path | head -n $QUANTITY | xargs -I {} adb pull "${screenshot_path}{}"

elif [[ $OS == "ios" ]]; then
    ssh_conn="-p $SSH_PORT $SSH_USER@$SSH_ADDRESS"
    echo $ssh_conn
    ssh $ssh_conn ls -t /var/mobile/Media/DCIM/ | head -n $QUANTITY | xargs -I {} scp -P 2222 "$ssh_conn:/var/mobile/Media/DCIM/{} ."
fi
