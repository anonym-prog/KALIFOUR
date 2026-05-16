#!/usr/bin/env bash
# KALI-ELITE - Password Cracking Module (5 Tools)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/colors.sh"

WORDLIST="$HOME/kali-elite/wordlists/rockyou.txt"
[ ! -f "$WORDLIST" ] && WORDLIST="/usr/share/wordlists/rockyou.txt"
[ ! -f "$WORDLIST" ] && WORDLIST="/usr/share/wordlists/rockyou.txt.gz"

while true; do
    clear
    header "🔑 PASSWORD CRACKING MODULE" $P
    echo -e "  ${R}[${Y}01${R}]${N} ${P}Hydra${N}        ${D}— Network login brute-force${N}"
    echo -e "  ${R}[${Y}02${R}]${N} ${P}John${N}         ${D}— John the Ripper hash cracker${N}"
    echo -e "  ${R}[${Y}03${R}]${N} ${P}Hashcat${N}      ${D}— GPU-accelerated password cracking${N}"
    echo -e "  ${R}[${Y}04${R}]${N} ${P}Medusa${N}       ${D}— Parallel network brute-forcer${N}"
    echo -e "  ${R}[${Y}05${R}]${N} ${P}Crunch${N}       ${D}— Wordlist generator${N}"
    echo -e "  ${R}[${Y}06${R}]${N} ${Y}🔙 Back to Main${N}"
    echo ""
    read -p "$(echo -e ${P}"[${Y}PASSWORD${P}]${N} > ")" ch
    
    case $ch in
        01|1|hydra)
            read -p "$(echo -e ${Y}"[?] Service (ssh/ftp/http-post-form/mysql): "${N})" service
            read -p "$(echo -e ${Y}"[?] Target: "${N})" target
            read -p "$(echo -e ${Y}"[?] Username [root]: "${N})" user
            [ -z "$user" ] && user="root"
            [ -z "$target" ] && { warning "Target required!"; continue; }
            
            tool_banner "HYDRA" "Password" $P
            echo -e "${C}1) Single user | 2) User list | 3) Custom${N}"
            read -p "> " mode
            case $mode in
                1) hydra -l "$user" -P "$WORDLIST" "$service://$target" -t 4 -V ;;
                2)
                    read -p "$(echo -e ${Y}"[?] User list file: "${N})" users
                    hydra -L "$users" -P "$WORDLIST" "$service://$target" -t 4 -V
                    ;;
                3)
                    read -p "$(echo -e ${Y}"[?] Full cmd: "${N})" cmd
                    eval "$cmd"
                    ;;
                *) hydra -l "$user" -P "$WORDLIST" "$service://$target" -t 4 -V ;;
            esac
            ;;
        02|2|john)
            read -p "$(echo -e ${Y}"[?] Hash file path: "${N})" hashfile
            [ -z "$hashfile" ] && { warning "Hash file required!"; continue; }
            [ ! -f "$hashfile" ] && { warning "File not found: $hashfile"; continue; }
            
            tool_banner "JOHN THE RIPPER" "Password" $P
            echo -e "${C}1) Auto-detect + crack | 2) Single crack | 3) Wordlist + rules | 4) Show results${N}"
            read -p "> " mode
            case $mode in
                1) john "$hashfile" --wordlist="$WORDLIST" ;;
                2) john --single "$hashfile" ;;
                3) john "$hashfile" --wordlist="$WORDLIST" --rules ;;
                4) john --show "$hashfile" ;;
                *) john "$hashfile" --wordlist="$WORDLIST" ;;
            esac
            ;;
        03|3|hashcat)
            read -p "$(echo -e ${Y}"[?] Hash file path: "${N})" hashfile
            [ -z "$hashfile" ] && { warning "Hash file required!"; continue; }
            [ ! -f "$hashfile" ] && { warning "File not found: $hashfile"; continue; }
            
            tool_banner "HASHCAT" "Password" $P
            echo -e "${C}Select hash mode:${N}"
            echo -e "  0 = MD5    | 100 = SHA1   | 1400 = SHA256"
            echo -e "  1000 = NTLM | 1800 = SHA512 | 3200 = bcrypt"
            echo -e "  5500 = NetNTLMv2 | 13100 = Kerberos"
            read -p "$(echo -e ${Y}"[?] Mode [0]: "${N})" mode
            [ -z "$mode" ] && mode=0
            
            echo -e "${C}1) Wordlist | 2) Brute-force | 3) Rule-based | 4) Show cracked${N}"
            read -p "> " attack
            case $attack in
                1) hashcat -m "$mode" "$hashfile" "$WORDLIST" --force -O ;;
                2) hashcat -m "$mode" "$hashfile" -a 3 ?a?a?a?a?a?a --force -O ;;
                3) hashcat -m "$mode" "$hashfile" "$WORDLIST" -r /usr/share/hashcat/rules/best64.rule --force -O ;;
                4) hashcat -m "$mode" "$hashfile" --show ;;
                *) hashcat -m "$mode" "$hashfile" "$WORDLIST" --force -O ;;
            esac
            ;;
        04|4|medusa)
            read -p "$(echo -e ${Y}"[?] Target: "${N})" target
            read -p "$(echo -e ${Y}"[?] Service (ssh/ftp/mysql): "${N})" service
            read -p "$(echo -e ${Y}"[?] Username [admin]: "${N})" user
            [ -z "$target" ] && { warning "Target required!"; continue; }
            [ -z "$service" ] && service="ssh"
            [ -z "$user" ] && user="admin"
            
            tool_banner "MEDUSA" "Password" $P
            medusa -h "$target" -u "$user" -P "$WORDLIST" -M "$service" -t 5 -f -v 6
            ;;
        05|5|crunch)
            tool_banner "CRUNCH" "Password" $P
            echo -e "${C}1) Minimal wordlist | 2) Custom charset | 3) Pattern-based${N}"
            read -p "> " mode
            case $mode in
                1)
                    read -p "$(echo -e ${Y}"[?] Min length: "${N})" min
                    read -p "$(echo -e ${Y}"[?] Max length: "${N})" max
                    [ -z "$min" ] && min=4
                    [ -z "$max" ] && max=8
                    crunch "$min" "$max" -o "$HOME/kali-elite/wordlists/crunch_$(date +%Y%m%d).txt"
                    ;;
                2)
                    read -p "$(echo -e ${Y}"[?] Min: "${N})" min
                    read -p "$(echo -e ${Y}"[?] Max: "${N})" max
                    read -p "$(echo -e ${Y}"[?] Charset (e.g. abc123): "${N})" set
                    [ -z "$min" ] && min=6; [ -z "$max" ] && max=10; [ -z "$set" ] && set="abcdefghijklmnopqrstuvwxyz0123456789"
                    crunch "$min" "$max" "$set" -o "$HOME/kali-elite/wordlists/crunch_$(date +%Y%m%d).txt"
                    ;;
                3)
                    read -p "$(echo -e ${Y}"[?] Pattern (e.g. @@@@####): "${N})" pattern
                    [ -z "$pattern" ] && pattern="@@@@@@@@"
                    crunch 0 0 -p "$pattern" -o "$HOME/kali-elite/wordlists/crunch_$(date +%Y%m%d).txt"
                    ;;
                *) crunch 6 8 -o wordlist.txt ;;
            esac
            [ -f "$HOME/kali-elite/wordlists/crunch_$(date +%Y%m%d).txt" ] && success "Wordlist generated!"
            ;;
        06|6|back|0) break ;;
        *) warning "Invalid option!" ;;
    esac
    echo ""
    read -p "$(echo -e ${D}"Press Enter..."${N)"
done
