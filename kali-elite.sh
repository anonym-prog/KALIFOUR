#!/usr/bin/env bash
# KALI-ELITE - Main Interactive Launcher

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'
B='\033[1;34m'; P='\033[1;35m'; C='\033[1;36m'; W='\033[1;37m'; N='\033[0m'; D='\033[2m'

header() { echo -e "${R}╔══════════════════════════════════════════════════════════╗${N}\n${R}║${N}  ${Y}◆${N} ${C}${1}${N} ${Y}◆${N}\n${R}╚══════════════════════════════════════════════════════════╝${N}"; }
success() { echo -e " ${G}[✓]${N} ${1}"; }
error() { echo -e " ${R}[✗]${N} ${1}"; }
info() { echo -e " ${C}[→]${N} ${1}"; }
confirm() { local yn; read -p "$(echo -e ${Y}"[?] ${1} [y/N]: "${N})" yn; case $yn in [Yy]*) return 0;; *) return 1;; esac; }

show_banner() {
    clear
    echo -e "${R}"
    echo "██╗  ██╗ █████╗ ██╗     ██╗         ███████╗██╗     ██╗████████╗███████╗"
    echo "██║ ██╔╝██╔══██╗██║     ██║         ██╔════╝██║     ██║╚══██╔══╝██╔════╝"
    echo "█████╔╝ ███████║██║     ██║         █████╗  ██║     ██║   ██║   █████╗  "
    echo "██╔═██╗ ██╔══██║██║     ██║         ██╔══╝  ██║     ██║   ██║   ██╔══╝  "
    echo "██║  ██╗██║  ██║███████╗███████╗    ███████╗███████╗██║   ██║   ███████╗"
    echo "╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝"
    echo -e "${N}"
    echo -e "${Y}                      ⚡ 40 Tools Pentest Framework ⚡${N}"
    echo ""
}

main_menu() {
    show_banner
    echo -e "${R}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${R}║${N}              ${Y}💀 KALI-ELITE MAIN MENU 💀${N}               ${R}║${N}"
    echo -e "${R}╚══════════════════════════════════════════════════════════╝${N}"
    echo ""
    echo -e "  ${R}[${Y}01${R}]${N} ${G}🔍 RECON${N}         ${D}───  8 tools  ───${N} ${C}Nmap, RustScan, Masscan${N}"
    echo -e "  ${R}[${Y}02${R}]${N} ${Y}📡 SCANNER${N}        ${D}───  6 tools  ───${N} ${C}Nuclei, Nikto, OpenVAS${N}"
    echo -e "  ${R}[${Y}03${R}]${N} ${R}💥 EXPLOIT${N}        ${D}───  6 tools  ───${N} ${C}Metasploit, BeEF${N}"
    echo -e "  ${R}[${Y}04${R}]${N} ${B}🌐 WEB APP${N}        ${D}───  6 tools  ───${N} ${C}BurpSuite, SQLMap${N}"
    echo -e "  ${R}[${Y}05${R}]${N} ${P}🔑 PASSWORD${N}       ${D}───  5 tools  ───${N} ${C}Hydra, John, Hashcat${N}"
    echo -e "  ${R}[${Y}06${R}]${N} ${Y}📶 WIFI${N}           ${D}───  4 tools  ───${N} ${C}Aircrack, Bettercap${N}"
    echo -e "  ${R}[${Y}07${R}]${N} ${C}👁️ OSINT${N}          ${D}───  3 tools  ───${N} ${C}Sherlock, theHarvester${N}"
    echo -e "  ${R}[${Y}08${R}]${N} ${P}⚙️ POST-EXP${N}       ${D}───  2 tools  ───${N} ${C}LinPEAS, Mimikatz${N}"
    echo -e "  ${R}[${Y}09${R}]${N} ${G}⚡ AUTO SCAN${N}      ${D}───  1 click ───${N} ${C}Full automated scan${N}"
    echo -e "  ${R}[${Y}10${R}]${N} ${Y}📊 REPORTS${N}        ${D}───  1 click ───${N} ${C}Generate pentest report${N}"
    echo -e "  ${R}[${Y}00${R}]${N} ${R}❌ EXIT${N}           ${D}───  Exit${N}"
    echo ""
    read -p "$(echo -e ${R}"[${Y}KALI-ELITE${R}]${N} > ")" ch

    case $ch in
        01|1|recon) module_recon ;;
        02|2|scanner) module_scanner ;;
        03|3|exploit) module_exploit ;;
        04|4|web) module_web ;;
        05|5|password) module_password ;;
        06|6|wifi) module_wifi ;;
        07|7|osint) module_osint ;;
        08|8|post) module_postexploit ;;
        09|9|scan) auto_scan ;;
        10|report) generate_report ;;
        00|0|exit|quit) echo -e "\n${R}Exiting KALI-ELITE. Stay sharp.${N}"; exit 0 ;;
        *) error "Invalid option!" ;;
    esac
    read -p "$(echo -e ${D}"Press Enter..."${N)"
    main_menu
}

module_recon() { header "🔍 RECONNAISSANCE (8 Tools)"; echo "1) Nmap  2) RustScan  3) Masscan  4) Amass  5) Subfinder  6) Whois  7) DNSRecon  8) WhatWeb  0) Back"; read -p "> " t; case $t in 1) read -p "Target: " x; nmap -sC -sV -O -A "$x";; 2) read -p "Target: " x; rustscan -a "$x";; 3) read -p "Range: " x; sudo masscan "$x" -p80,443 --rate=1000;; 4) read -p "Domain: " x; amass enum -d "$x";; 5) read -p "Domain: " x; subfinder -d "$x" -all;; 6) read -p "Domain: " x; whois "$x";; 7) read -p "Domain: " x; dnsrecon -d "$x" -a;; 8) read -p "URL: " x; whatweb "$x" -v;; esac; }

module_scanner() { header "📡 VULNERABILITY SCANNER (6 Tools)"; echo "1) Nuclei  2) Nikto  3) Wapiti  4) Arachni  5) Skipfish  0) Back"; read -p "> " t; case $t in 1) read -p "URL: " x; nuclei -u "$x" -severity low,medium,high,critical;; 2) read -p "Host: " x; nikto -h "$x";; 3) read -p "URL: " x; wapiti -u "$x" -o /tmp/wapiti;; 4) read -p "URL: " x; arachni "$x";; 5) read -p "URL: " x; skipfish -o /tmp/skipfish "$x";; esac; }

module_exploit() { header "💥 EXPLOITATION (6 Tools)"; echo "1) Metasploit  2) Searchsploit  3) BeEF  4) Commix  5) RouterSploit  0) Back"; read -p "> " t; case $t in 1) msfconsole -q;; 2) read -p "Search: " x; searchsploit "$x";; 3) beef-xss;; 4) read -p "URL: " x; commix --url="$x";; 5) rsf.py;; esac; }

module_web() { header "🌐 WEB APPLICATION (6 Tools)"; echo "1) BurpSuite  2) SQLMap  3) XSStrike  4) Gobuster  5) Ffuf  6) Wfuzz  0) Back"; read -p "> " t; case $t in 1) burpsuite &;; 2) read -p "URL: " x; sqlmap -u "$x" --batch;; 3) read -p "URL: " x; xsstrike -u "$x";; 4) read -p "URL: " x; read -p "Wordlist: " w; gobuster dir -u "$x" -w "$w";; 5) read -p "URL+FUZZ: " x; read -p "Wordlist: " w; ffuf -u "$x" -w "$w";; 6) read -p "URL+FUZZ: " x; read -p "Wordlist: " w; wfuzz -w "$w" "$x";; esac; }

module_password() { header "🔑 PASSWORD CRACKING (5 Tools)"; echo "1) Hydra  2) John  3) Hashcat  4) Medusa  5) Crunch  0) Back"; read -p "> " t; case $t in 1) read -p "Target: " x; hydra -l root -P /usr/share/wordlists/rockyou.txt ssh://"$x";; 2) read -p "Hash file: " x; john "$x";; 3) read -p "Hash file: " x; hashcat -m 0 "$x" /usr/share/wordlists/rockyou.txt --force;; 4) read -p "Target: " x; medusa -h "$x" -u admin -P /usr/share/wordlists/rockyou.txt -M ssh;; 5) read -p "Min Max Charset: " m n c; crunch "$m" "$n" "$c" -o wordlist.txt;; esac; }

module_wifi() { header "📶 WIFI HACKING (4 Tools)"; echo "1) Aircrack-ng  2) Bettercap  3) Kismet  0) Back"; read -p "> " t; case $t in 1) aircrack-ng;; 2) sudo bettercap;; 3) sudo kismet;; esac; }

module_osint() { header "👁️ OSINT (3 Tools)"; echo "1) Sherlock  2) theHarvester  3) Recon-ng  0) Back"; read -p "> " t; case $t in 1) read -p "Username: " x; sherlock "$x";; 2) read -p "Domain: " x; theHarvester -d "$x" -b google;; 3) recon-ng;; esac; }

module_postexploit() { header "⚙️ POST EXPLOITATION (2 Tools)"; echo "1) LinPEAS  2) Mimikatz Guide  0) Back"; read -p "> " t; case $t in 1) bash /opt/kali-elite/linpeas.sh 2>/dev/null || curl -sL https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh | bash;; 2) echo "Download from: https://github.com/gentilkiwi/mimikatz";; esac; }

auto_scan() {
    read -p "$(echo -e ${Y}"Target: "${N})" target
    [ -z "$target" ] && { error "Target required!"; return; }
    local report="$HOME/kali-elite/reports/scan_${target}_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$report"
    
    header "⚡ AUTO SCAN: $target"
    echo -e "${C}[1/4]${N} Nmap..."; nmap -sC -sV -T4 "$target" -oN "$report/nmap.txt" 2>/dev/null; echo -e "  ${G}✓${N}"
    echo -e "${C}[2/4]${N} Nuclei..."; nuclei -u "http://$target" -severity medium,high,critical -o "$report/nuclei.txt" 2>/dev/null || nuclei -u "https://$target" -severity medium,high,critical -o "$report/nuclei.txt" 2>/dev/null; echo -e "  ${G}✓${N}"
    echo -e "${C}[3/4]${N} WhatWeb..."; whatweb "$target" -v > "$report/whatweb.txt" 2>/dev/null; echo -e "  ${G}✓${N}"
    echo -e "${C}[4/4]${N} Nikto..."; nikto -h "$target" -o "$report/nikto.txt" 2>/dev/null; echo -e "  ${G}✓${N}"
    echo -e "${G}Scan complete! Reports:${N} $report"
}

generate_report() {
    local report="$HOME/kali-elite/reports/pentest_report_$(date +%Y%m%d).md"
    {
        echo "# KALI-ELITE Pentest Report"
        echo "**Date:** $(date)"
        echo "**Host:** $(hostname)"
        echo ""
        echo "## Scans Performed"
        ls -1 "$HOME/kali-elite/reports/" 2>/dev/null | while read f; do echo "- $f"; done
        echo ""
        echo "## Tools Available"
        for tool in nmap nuclei metasploit sqlmap hydra john hashcat bettercap; do
            command -v "$tool" &>/dev/null && echo "- $tool: $(which $tool)"
        done
    } > "$report"
    success "Report saved: $report"
    cat "$report"
}

case "${1,,}" in
    recon) module_recon ;; scanner) module_scanner ;; exploit) module_exploit ;;
    web) module_web ;; password) module_password ;; wifi) module_wifi ;;
    osint) module_osint ;; post) module_postexploit ;;
    scan) auto_scan "$2" ;; report) generate_report ;;
    --setup) mkdir -p "$HOME/kali-elite"/{reports,wordlists,configs}; success "Setup done!" ;;
    --help) echo "Usage: kali-elite [module]"; echo "Modules: recon, scanner, exploit, web, password, wifi, osint, post, scan
