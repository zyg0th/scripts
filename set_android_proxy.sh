#!/usr/bin/env bash

VERBOSE="false"
PROXY=""

while [[ $# -gt 0 ]]; do
    case $1 in
        proxy)
            PROXY="$1"
            shift
        ;;

        -v|--verbose)
            VERBOSE="true"
            shift
        ;;
        
        -h|--help)
            echo "Usage: $(basename "$0") proxy <ip:port> [-v|--verbose] [-h|--help]

Redirect a connected Android device's HTTP/HTTPS traffic to an external
proxy ip:port via iptables DNAT (requires root).

Arguments:
  proxy <ip:port>   target proxy address, e.g. proxy 192.168.1.100:8080

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

adb shell su -c "iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination $PROXY"
adb shell su -c "iptables -t nat -A OUTPUT -p tcp --dport 443 -j DNAT --to-destination $PROXY"

$VERBOSE && echo "Info: Remember to enable invisible proxy on burp suite"