#!/bin/bash

help() {
    echo 'Syntax:'
    echo "$0 mount <img_file> <mapper point> <mount path>"
    echo "$0 mount <img_file> <mount path>"
    echo "$0 umount <mapper point>"
}

if [ $# -eq 0 ]; then
    help
else
    if [ "$1" == "umount" ]; then
        if [ ! $# -eq 2 ]; then
            help
            exit
        fi

        mapper_point=$2
        loop_dev="$(cryptsetup status "$mapper_point" | grep device | sed -e 's/  */ /g' -e 's/^ *\(.*\) *$/\1/' | cut -d' ' -f2)"

        umount "/dev/mapper/$mapper_point"
        cryptsetup luksClose "$mapper_point"
        losetup -d "$loop_dev"
    elif [ "$1" == "mount" ]; then
        if [ $# -lt 3 ]; then
            help
            exit
        elif [ $# -eq 3 ]; then
            img=$2
            mapper_point="$(basename "$img" | cut -d. -f1)"
            mount_path=$3
        else
            img=$2
            mapper_point=$3
            mount_path=$4
        fi

        losetup -f "$img"
        loop_dev="$(losetup | grep "$img" | cut -d' ' -f1)"
        cryptsetup luksOpen "$loop_dev" "$mapper_point"
        mount "/dev/mapper/$mapper_point" "$mount_path"
    else
        help
    fi
fi
