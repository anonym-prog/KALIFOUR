#!/usr/bin/env bash
# KALI-ELITE - Reconnaissance Module (8 Tools)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/colors.sh"

show_menu() {
    header "🔍 RECONNAISSANCE MODULE" $G
    echo -e "  ${R}[${Y}01${R}]${N} ${G}Nmap${N}        ${D}— Port scanner & service detection${N}"
    echo -e "  ${R}[${Y}02${R}]${N} ${G}RustScan${N}     ${D}— Ultra-fast port scanner${N}"
    echo -e "  ${R}[${Y}03${R}]${N} ${G}Masscan${N}      ${D}— Mass IP/port scanner${N}"
    echo -e "  ${R}[${Y}04${R}]${N} ${G}Amass${N}        ${D}— Deep subdomain enumeration${N}"
    echo -e "  ${R}[${Y}05${R}]${N} ${G}Subfinder${N}    ${D}— Passive subdomain discovery${N}"
    echo -e "  ${R}[${Y}06${R}]${N} ${G}Whois${N}        ${D}— Domain registration lookup${N}"
    echo -e "  ${R}[${Y}07${R}]${N} ${G}DNSRecon${N}     ${D}— DNS enumeration${N}"
    echo -e "  ${R}[${Y}08${R}]${N} ${G}WhatWeb${N}      ${D}— Website technology detection${N}"
    echo -e "  ${R}[${Y}09${R}]${N} ${Y}🔙 Back to Main${N}"
    echo ""
    read -p "$(echo -e ${G}"[${Y}RECON${G}]${N} > ")" ch
}

# Main loop
while true; do
    show_menu
    
    case $ch in
        01|1|nmap)
            read -p "$(echo -e ${Y}"[?] Target: "${N})" target
            [ -z "$target" ] && { warning "Target required!"; continue; }
            tool_banner "NMAP" "Recon" $G
            echo -e "${C}Quick (1) | Full (2) | Vuln (3):${N}"
            read -p "> " mode
            case $mode in
                1) sudo nmap -sC -sV -T4 "$target" -oN "$HOME/kali-elite/reports/nmap_quick.txt" ;;
                2) sudo nmap -sC -sV -O -A -p- --min-rate=1000 "$target" -oN "$HOME/kali-elite/reports/nmap_full.txt" ;;
                3) sudo nmap -sV --script vuln "$target" -oN "$HOME/kali-elite/reports/nmap_vuln.txt" ;;
                *) sudo nmap -sC -sV -T4 "$target" ;;
            esac
            success "Nmap scan complete!"
            ;;
        02|2|rustscan)
            read -p "$(echo -e ${Y}"[?] Target: "${N})" target
            [ -z "$target" ] && { warning "Target required!"; continue; }
            tool_banner "RUSTSCAN" "Recon" $G
            rustscan -a "$target" --ulimit 5000 -- -sC -sV
            success "RustScan complete!"
            ;;
        03|3|masscan)
            read -p "$(echo -e ${Y}"[?] Range (e.g. 192.168.1.0/24): "${N})" range
            read -p "$(echo -e ${Y}"[?] Ports (e.g. 80,443,22): "${N})" ports
            [ -z "$range" ] && { warning "Range required!"; continue; }
            [ -z "$ports" ] && ports="80,443,22,8080,3306"
            tool_banner "MASSCAN" "Recon" $G
            sudo masscan "$range" -p"$ports" --rate=1000
            success "Masscan complete!"
            ;;
        04|4|amass)
            read -p "$(echo -e ${Y}"[?] Domain: "${N})" domain
            [ -z "$domain" ] && { warning "Domain required!"; continue; }
            tool_banner "AMASS" "Recon" $G
            echo -e "${C}Passive (1) | Active (2) | All (3):${N}"
            read -p "> " mode
            case $mode in
                1) amass enum -passive -d "$domain" -o "$HOME/kali-elite/reports/amass_passive.txt" ;;
                2) amass enum -active -d "$domain" -o "$HOME/kali-elite/reports/amass_active.txt" ;;
                3) amass enum -d "$domain" -o "$HOME/kali-elite/reports/amass_full.txt" ;;
                *) amass enum -passive -d "$domain" ;;
            esac
            success "Amass enumeration complete!"
            ;;
        05|5|subfinder)
            read -p "$(echo -e ${Y}"[?] Domain: "${N})" domain
            [ -z "$domain" ] && { warning "Domain required!"; continue; }
            tool_banner "SUBFINDER" "Recon" $G
            subfinder -d "$domain" -all -o "$HOME/kali-elite/reports/subfinder_$(date +%Y%m%d).txt"
            success "Subdomains saved to reports/"
            ;;
        06|6|whois)
            read -p "$(echo -e ${Y}"[?] Domain/IP: "${N})" target
            [ -z "$target" ] && { warning "Domain required!"; continue; }
            tool_banner "WHOIS" "Recon" $G
            whois "$target" | head -50
            ;;
        07|7|dnsrecon)
            read -p "$(echo -e ${Y}"[?] Domain: "${N})" domain
            [ -z "$domain" ] && { warning "Domain required!"; continue; }
            tool_banner "DNSRECON" "Recon" $G
            echo -e "${C}Standard (1) | Zone Transfer (2) | Brute Force (3):${N}"
            read -p "> " mode
            case $mode in
                1) dnsrecon -d "$domain" -a ;;
                2) dnsrecon -d "$domain" -t axfr ;;
                3) dnsrecon -d "$domain" -D /usr/share/wordlists/dirb/common.txt -t brt ;;
                *) dnsrecon -d "$domain" -a ;;
            esac
            ;;
        08|8|whatweb)
            read -p "$(echo -e ${Y}"[?] URL: "${N})" url
            [ -z "$url" ] && { warning "URL required!"; continue; }
            tool_banner "WHATWEB" "Recon" $G
            whatweb "$url" -v --colour=never | tee "$HOME/kali-elite/reports/whatweb_$(date +%Y%m%d).txt"
            success "Technology detection complete!"
            ;;
        09|9|back|0) break ;;
        *) warning "Invalid option!" ;;
    esac
    echo ""
    read -p "$(echo -e ${D}"Press Enter..."${N)"
done
