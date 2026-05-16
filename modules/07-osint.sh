#!/usr/bin/env bash
# KALI-ELITE - OSINT Module (3 Tools)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/colors.sh"

while true; do
    clear
    header "👁️ OSINT MODULE" $C
    echo -e "  ${R}[${Y}01${R}]${N} ${C}Sherlock${N}      ${D}— Social media username search${N}"
    echo -e "  ${R}[${Y}02${R}]${N} ${C}theHarvester${N}  ${D}— Email, subdomain, employee gather${N}"
    echo -e "  ${R}[${Y}03${R}]${N} ${C}Recon-ng${N}      ${D}— Full reconnaissance framework${N}"
    echo -e "  ${R}[${Y}04${R}]${N} ${Y}🔙 Back to Main${N}"
    echo ""
    read -p "$(echo -e ${C}"[${Y}OSINT${C}]${N} > ")" ch
    
    case $ch in
        01|1|sherlock)
            read -p "$(echo -e ${Y}"[?] Username to search: "${N})" username
            [ -z "$username" ] && { warning "Username required!"; continue; }
            tool_banner "SHERLOCK" "OSINT" $C
            sherlock "$username" --output "$HOME/kali-elite/reports/sherlock_${username}_$(date +%Y%m%d).txt"
            success "Results saved to reports/"
            ;;
        02|2|theharvester)
            read -p "$(echo -e ${Y}"[?] Domain: "${N})" domain
            [ -z "$domain" ] && { warning "Domain required!"; continue; }
            tool_banner "THEHARVESTER" "OSINT" $C
            echo -e "${C}1) Google | 2) Bing | 3) All sources | 4) DNS brute${N}"
            read -p "> " mode
            case $mode in
                1) theHarvester -d "$domain" -b google -f "$HOME/kali-elite/reports/harvester_${domain}.html" ;;
                2) theHarvester -d "$domain" -b bing -f "$HOME/kali-elite/reports/harvester_${domain}.html" ;;
                3) theHarvester -d "$domain" -b all -f "$HOME/kali-elite/reports/harvester_${domain}.html" ;;
                4) theHarvester -d "$domain" -b dns -f "$HOME/kali-elite/reports/harvester_${domain}.html" ;;
                *) theHarvester -d "$domain" -b google ;;
            esac
            success "Harvest complete! Check reports/"
            ;;
        03|3|recon-ng)
            tool_banner "RECON-NG" "OSINT" $C
            recon-ng
            ;;
        04|4|back|0) break ;;
        *) warning "Invalid option!" ;;
    esac
    echo ""
    read -p "$(echo -e ${D}"Press Enter..."${N)"
done
