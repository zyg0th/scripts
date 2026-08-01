#!/usr/bin/env bash

PACKAGE_LIST=()
VERBOSE="false"

while [[ $# -gt 0 ]]; do
    case $1 in
        [a-z][a-z0-9_.]*[a-z0-9])
            PACKAGE_LIST+=("$1")
            shift
        ;;

        -v|--verbose)
            VERBOSE="true"
            shift
        ;;
        
        -h|--help)
            echo "Usage: $(basename "$0") <package.name> [package.name...] [-v|--verbose] [-h|--help]

Extract shared_prefs from a connected Android device via adb (requires root).

Arguments:
  package.name      one or more Android package names to extract (e.g. com.example.app)

Options:
  -v, --verbose     print extra info while running
  -h, --help        show this help message"
            exit
        ;;
        *)
            echo "Error: unknow option '$1'"
            exit
        ;;
    esac
done

$VERBOSE && echo "Info: I'll download ${#PACKAGE_LIST[@]} package(s)"

for package in "${PACKAGE_LIST[@]}"; do
    compressed="${package}_shared_prefs.tar.gz"
    adb shell su -c "tar czvf /sdcard/Download/$compressed -C /data/data/$package shared_prefs"
    adb pull /sdcard/Download/$compressed
    adb shell su -c "rm /sdcard/Download/$compressed"
    dest="extracted_shared_prefs/${package}/"
    mkdir -p $dest
    mv ./$compressed $dest
    tar -xzvf $dest/$compressed -C $dest
done