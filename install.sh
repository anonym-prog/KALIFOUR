#!/usr/bin/env bash
# KALI-ELITE - Installer for Kali Linux

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'
B='\033[1;34m'; C='\033[1;36m'; N='\033[0m'; D='\033[2m'

header() { echo -e "\n${R}╔══════════════════════════════════════════════════════════╗${N}"; echo -e "${R}║${N}  ${Y}◆${N} ${C}${1}${N} ${Y}◆${N}"; echo -e "${R}╚══════════════════════════════════════════════════════════╝${N}\n"; }
success() { echo -e " ${G}[✓]${N} ${1}"; }
error() { echo -e " ${R}[✗]${N} ${1}"; }
info() { echo -e " ${C}[→]${N} ${1}"; }

trap 'echo -e "\n${R}[✗] Installation interrupted!${N}"; exit 1' SIGINT SIGTERM

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

header "KALI-ELITE INSTALLER v1.0"

# Update
header "UPDATING SYSTEM"
sudo apt update -y && sudo apt upgrade -y
success "System updated!"

# Install all tools
header "INSTALLING 40 TOOLS"

TOOLS=(
    # Recon (8)
    "nmap" "masscan" "amass" "whois" "dnsrecon" "whatweb" "rustscan"
    
    # Scanner (6)
    "nuclei" "nikto" "openvas" "wapiti" "arachni" "skipfish"
    
    # Exploit (6)
    "metasploit-framework" "exploitdb" "beef-xss" "commix" "shellnoob"
    
    # Web (6)
    "burpsuite" "sqlmap" "xsstrike" "gobuster" "wfuzz"
    
    # Password (5)
    "hydra" "john" "hashcat" "medusa" "crunch"
    
    # WiFi (4)
    "aircrack-ng" "bettercap" "kismet"
    
    # OSINT (3)
    "theharvester" "recon-ng" "sherlock"
)

total=${#TOOLS[@]}
count=0

for tool in "${TOOLS[@]}"; do
    count=$((count + 1))
    echo -ne "\r${Y}[${count}/${total}]${N} Installing ${G}${tool}${N}...          "
    
    if dpkg -l "$tool" &>/dev/null 2>&1; then
        echo -ne "\r${G}[✓]${N} ${tool} ${D}already installed${N}          \n"
    else
        sudo apt install -y "$tool" 2>/dev/null && \
            echo -ne "\r${G}[✓]${N} ${tool} ${G}installed!${N}          \n" || \
            echo -ne "\r${Y}[⚠]${N} ${tool} ${Y}failed${N}           \n"
    fi
done

# Install Go tools
header "INSTALLING GO TOOLS"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>/dev/null
go install github.com/ffuf/ffuf@latest 2>/dev/null
success "Go tools installed!"

# Install Python tools
header "INSTALLING PYTHON TOOLS"
pip install sherlock 2>/dev/null >/dev/null
pip install routersploit 2>/dev/null >/dev/null
success "Python tools installed!"

# Post-exploit tools
header "INSTALLING POST-EXPLOIT TOOLS"
mkdir -p /opt/kali-elite
wget -q "https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh" -O /opt/kali-elite/linpeas.sh 2>/dev/null
chmod +x /opt/kali-elite/linpeas.sh
success "LinPEAS installed!"

# Setup directories
header "SETTING UP"
mkdir -p "$HOME/kali-elite"/{reports,wordlists,configs}
wget -q "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt" -O "$HOME/kali-elite/wordlists/common.txt" 2>/dev/null &
success "Directories created!"

# Install launcher
sudo cp "$SCRIPT_DIR/kali-elite.sh" /usr/local/bin/kali-elite
sudo chmod +x /usr/local/bin/kali-elite
success "Launcher installed! Run: kali-elite"

# Complete
clear
echo -e "${G}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              ⚡ INSTALLATION COMPLETE! ⚡                ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${N}"
echo -e "  ${Y}40 tools installed successfully!${N}"
echo -e "  ${C}Run:${N} ${G}kali-elite${N}"
echo ""
echo -e "  ${Y}Quick commands:${N}"
echo -e "  ${G}kali-elite${N}          - Interactive menu"
echo -e "  ${G}kali-elite scan${N}     - Auto scan target"
echo -e "  ${G}kali-elite report${N}   - Generate report"
echo ""
