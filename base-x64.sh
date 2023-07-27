#!/bin/bash
echo "========================="
echo "| BASE VOID x86_64    |"
echo " ------------------------"
CURRENT=https://mirrors.servercentral.com/voidlinux/current
MUTILIB=https://mirrors.servercentral.com/voidlinux/current/multilib
NONFREE=https://mirrors.servercentral.com/voidlinux/current/nonfree

FILENAME="void-live-unofficial"
DATE=$(date +%Y%m%d)
KERNEL=$(uname -r)
BUILDDIR="$(pwd)/build"

retry=0
# Run mklive command with set architechure, repos and package list
until [ -f ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso ];do

    ((retry++))
    if [[ $retry -eq 2 ]];then
        break
    fi

    sudo ./mklive.sh \
        -a x86_64 \
        -r "${CURRENT}" \
        -r "${MULTILIB}" \
        -I "$(pwd)/extra" \
        -p "$(grep '^[^#].' base-x64.packages)" \
        -T "${DESKTOP}" \
        -o ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso \
	-S "NetworkManager acpid dbus"
    
done

# Make sure resulting ISO exists and sent error to webpage if not
if [ ! -f ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso ];then   
        echo "Error: ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso : does not exist! Aborting!"
        echo "ERR=1" > error-status.txt
        exit 1
fi

# Add iso file to checksum list
sha256sum ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso >> sha256sums.txt



# Check if checksum file exists, send error to webpage if not
if [ ! -f sha256sums.txt ];then
    echo "Missing checksum file, aborting!"
    echo "ERR=1" > error-status.txt
    exit 1
fi

# make sure build directory exists and create it if not
if [ ! -d "${BUILDDIR}" ];then
    mkdir ${BUILDDIR}
fi

# Move the iso file to the build directory
mv ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso build
