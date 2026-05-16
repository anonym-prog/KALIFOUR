#!/usr/bin/env bash
# KALI-ELITE - Vulnerability Scanner Module (6 Tools)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/colors.sh"

while true; do
    clear
    header "📡 VULNERABILITY SCANNER MODULE" $Y
    echo -e "  ${R}[${Y}01${R}]${N} ${Y}Nuclei${N}       ${D}— Template-based vulnerability scanner (9000+ templates)${N}"
    echo -e "  ${R}[${Y}02${R}]${N} ${Y}Nikto${N}        ${D}— Web server scanner${N}"
    echo -e "  ${R}[${Y}03${R}]${N} ${Y}OpenVAS${N}      ${D}— Full vulnerability assessment system${N}"
    echo -e "  ${R}[${Y}04${R}]${N} ${Y}Wapiti${N}       ${D}— Web app vulnerability scanner${N}"
    echo -e "  ${R}[${Y}05${R}]${N} ${Y}Arachni${N}      ${D}— Web app security scanner framework${N}"
    echo -e "  ${R}[${Y}06${R}]${N} ${Y}Skipfish${N}     ${D}— Web app security scanner${N}"
    echo -e "  ${R}[${Y}07${R}]${N} ${Y}🔙 Back to Main${N}"
    echo ""
    read -p "$(echo -e ${Y}"[${Y}SCANNER${Y}]${N} > ")" ch
    
    case $ch in
        01|1|nuclei)
            read -p "$(echo -e ${Y}"[?] Target URL: "${N})" target
            [ -z "$target" ] && { warning "Target required!"; continue; }
            tool_banner "NUCLEI" "Scanner" $Y
            echo -e "${C}Quick (1) | Full (2) | Critical only (3):${N}"
            read -p "> " mode
            case $mode in
                1) nuclei -u "$target" -severity medium,high,critical -o "$HOME/kali-elite/reports/nuclei_quick.txt" ;;
                2) nuclei -u "$target" -severity low,medium,high,critical -o "$HOME/kali-elite/reports/nuclei_full.txt" ;;
                3) nuclei -u "$target" -severity critical -o "$HOME/kali-elite/reports/nuclei_critical.txt" ;;
                *) nuclei -u "$target" -severity medium,high,critical ;;
            esac
            success "Nuclei scan complete! Check reports/"
            ;;
        02|2|nikto)
            read -p "$(echo -e ${Y}"[?] Target: "${N})" target
            [ -z "$target" ] && { warning "Target required!"; continue; }
            tool_banner "NIKTO" "Scanner" $Y
            nikto -h "$target" -o "$HOME/kali-elite/reports/nikto_$(date +%Y%m%d).html" -Format html
            success "Nikto scan saved to reports/"
            ;;
        03|3|openvas)
            tool_banner "OPENVAS" "Scanner" $Y
            echo -e "${C}1) Start OpenVAS${N}"
            echo -e "${C}2) Check setup${N}"
            echo -e "${C}3) Stop OpenVAS${N}"
            read -p "> " mode
            case $mode in
                1) sudo gvm-start ;;
                2) sudo gvm-check-setup ;;
                3) sudo gvm-stop ;;
                *) sudo gvm-start ;;
            esac
            ;;
        04|4|wapiti)
            read -p "$(echo -e ${Y}"[?] Target URL: "${N})" target
            [ -z "$target" ] && { warning "Target required!"; continue; }
            tool_banner "WAPITI" "Scanner" $Y
            wapiti -u "$target" -o "$HOME/kali-elite/reports/wapiti_$(date +%Y%m%d)"
            success "Wapiti scan saved to reports/"
            ;;
        05|5|arachni)
            read -p "$(echo -e ${Y}"[?] Target URL: "${N})" target
            [ -z "$target" ] && { warning "Target required!"; continue; }
            tool_banner "ARACHNI" "Scanner" $Y
            arachni "$target" --report-save-path="$HOME/kali-elite/reports/arachni_$(date +%Y%m%d).afr"
            success "Arachni scan complete!"
            ;;
        06|6|skipfish)
            read -p "$(echo -e ${Y}"[?] Target URL: "${N})" target
            [ -z "$target" ] && { warning "Target required!"; continue; }
            tool_banner "SKIPFISH" "Scanner" $Y
            sudo skipfish -o "$HOME/kali-elite/reports/skipfish_$(date +%Y%m%d)" "$target"
            success "Skipfish scan saved to reports/"
            ;;
        07|7|back|0) break ;;
        *) warning "Invalid option!" ;;
    esac
    echo ""
    read -p "$(echo -e ${D}"Press Enter..."${N)"
done
