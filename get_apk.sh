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

Pull APK(s) from a connected Android device via adb.

Arguments:
  package      one or more Android package names to pull (e.g. com.example.app)

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

for package in ${PACKAGE_LIST[@]}; do
    adb shell pm path $package | sed 's/package://' | xargs -I{} adb pull {}
done