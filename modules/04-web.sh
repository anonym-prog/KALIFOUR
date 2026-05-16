#!/usr/bin/env bash
# KALI-ELITE - Web Application Module (6 Tools)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/colors.sh"

while true; do
    clear
    header "🌐 WEB APPLICATION MODULE" $B
    echo -e "  ${R}[${Y}01${R}]${N} ${B}BurpSuite${N}     ${D}— Web app testing proxy + scanner${N}"
    echo -e "  ${R}[${Y}02${R}]${N} ${B}SQLMap${N}        ${D}— SQL injection automation${N}"
    echo -e "  ${R}[${Y}03${R}]${N} ${B}XSStrike${N}      ${D}— XSS vulnerability scanner${N}"
    echo -e "  ${R}[${Y}04${R}]${N} ${B}Gobuster${N}      ${D}— Directory/DNS brute-force${N}"
    echo -e "  ${R}[${Y}05${R}]${N} ${B}Ffuf${N}          ${D}— Fast web fuzzer${N}"
    echo -e "  ${R}[${Y}06${R}]${N} ${B}Wfuzz${N}         ${D}— Web fuzzer / bruteforcer${N}"
    echo -e "  ${R}[${Y}07${R}]${N} ${Y}🔙 Back to Main${N}"
    echo ""
    read -p "$(echo -e ${B}"[${Y}WEB${B}]${N} > ")" ch
    
    case $ch in
        01|1|burp)
            tool_banner "BURPSUITE" "Web App" $B
            echo -e "${C}1) Launch BurpSuite${N}"
            echo -e "${C}2) Proxy setup guide${N}"
            echo -e "${C}3) CA certificate guide${N}"
            read -p "> " mode
            case $mode in
                1) burpsuite 2>/dev/null & success "BurpSuite launched in background!" ;;
                2)
                    echo -e "${Y}Firefox Proxy Setup:${N}"
                    echo -e "  Settings → Network → Connection Settings"
                    echo -e "  Manual proxy: 127.0.0.1:8080"
                    echo -e "  ✓ Also use for HTTPS"
                    echo ""
                    echo -e "${Y}Burp Proxy Setup:${N}"
                    echo -e "  Proxy → Proxy Settings → Add"
                    echo -e "  Bind: 127.0.0.1:8080"
                    echo -e "  ✓ Support invisible proxying"
                    ;;
                3)
                    echo -e "${Y}CA Certificate Installation:${N}"
                    echo -e "  1. Proxy running → http://127.0.0.1:8080/"
                    echo -e "  2. Click 'CA Certificate' → save cacert.der"
                    echo -e "  3. Firefox → Settings → Certificates → Import"
                    echo -e "  4. ✓ Trust this CA to identify websites"
                    ;;
            esac
            ;;
        02|2|sqlmap)
            read -p "$(echo -e ${Y}"[?] Target URL (with parameter): "${N})" url
            [ -z "$url" ] && { warning "URL required!"; continue; }
            tool_banner "SQLMAP" "Web App" $B
            echo -e "${C}1) Basic test | 2) Get databases | 3) Dump all | 4) Custom${N}"
            read -p "> " mode
            case $mode in
                1) sqlmap -u "$url" --batch --random-agent --level=2 --risk=1 ;;
                2) sqlmap -u "$url" --batch --random-agent --dbs ;;
                3) sqlmap -u "$url" --batch --random-agent --all ;;
                4)
                    read -p "$(echo -e ${Y}"[?] Extra options: "${N})" opts
                    sqlmap -u "$url" --batch --random-agent $opts
                    ;;
                *) sqlmap -u "$url" --batch ;;
            esac
            success "SQLMap scan complete!"
            ;;
        03|3|xsstrike)
            read -p "$(echo -e ${Y}"[?] Target URL: "${N})" url
            [ -z "$url" ] && { warning "URL required!"; continue; }
            tool_banner "XSSTRIKE" "Web App" $B
            echo -e "${C}1) Quick scan | 2) Crawl + scan | 3) Custom${N}"
            read -p "> " mode
            case $mode in
                1) xsstrike -u "$url" --timeout=10 ;;
                2) xsstrike -u "$url" --crawl --timeout=10 ;;
                3)
                    read -p "$(echo -e ${Y}"[?] Extra options: "${N})" opts
                    xsstrike -u "$url" $opts
                    ;;
                *) xsstrike -u "$url" ;;
            esac
            ;;
        04|4|gobuster)
            read -p "$(echo -e ${Y}"[?] Target URL: "${N})" url
            [ -z "$url" ] && { warning "URL required!"; continue; }
            read -p "$(echo -e ${Y}"[?] Wordlist path [/usr/share/wordlists/dirb/common.txt]: "${N})" wordlist
            [ -z "$wordlist" ] && wordlist="/usr/share/wordlists/dirb/common.txt"
            tool_banner "GOBUSTER" "Web App" $B
            echo -e "${C}1) Directory brute | 2) DNS subdomain | 3) VHost${N}"
            read -p "> " mode
            case $mode in
                1) gobuster dir -u "$url" -w "$wordlist" -t 50 ;;
                2) 
                    read -p "$(echo -e ${Y}"[?] Domain: "${N})" domain
                    gobuster dns -d "$domain" -w "$wordlist" -t 50
                    ;;
                3) gobuster vhost -u "$url" -w "$wordlist" -t 50 ;;
                *) gobuster dir -u "$url" -w "$wordlist" -t 50 ;;
            esac
            ;;
        05|5|ffuf)
            read -p "$(echo -e ${Y}"[?] URL (use FUZZ keyword): "${N})" url
            [ -z "$url" ] && { warning "URL with FUZZ required!"; continue; }
            read -p "$(echo -e ${Y}"[?] Wordlist: "${N})" wordlist
            [ -z "$wordlist" ] && wordlist="/usr/share/wordlists/dirb/common.txt"
            tool_banner "FFUF" "Web App" $B
            echo -e "${C}1) Directory fuzz | 2) Parameter fuzz | 3) Extension fuzz${N}"
            read -p "> " mode
            case $mode in
                1) ffuf -u "$url" -w "$wordlist" -t 50 ;;
                2) ffuf -u "$url" -w "$wordlist" -t 50 -fs 0 ;;
                3) ffuf -u "$url" -w "$wordlist" -e .php,.asp,.aspx,.jsp,.txt -t 50 ;;
                *) ffuf -u "$url" -w "$wordlist" -t 50 ;;
            esac
            ;;
        06|6|wfuzz)
            read -p "$(echo -e ${Y}"[?] URL (use FUZZ): "${N})" url
            [ -z "$url" ] && { warning "URL required!"; continue; }
            read -p "$(echo -e ${Y}"[?] Wordlist: "${N})" wordlist
            [ -z "$wordlist" ] && wordlist="/usr/share/wordlists/wfuzz/general/common.txt"
            tool_banner "WFUZZ" "Web App" $B
            echo -e "${C}1) Directory | 2) Parameter | 3) Header | 4) Custom${N}"
            read -p "> " mode
            case $mode in
                1) wfuzz -w "$wordlist" -t 50 "$url" ;;
                2) wfuzz -w "$wordlist" -t 50 -d "param=FUZZ" "$url" ;;
                3) wfuzz -w "$wordlist" -t 50 -H "Header: FUZZ" "$url" ;;
                4) 
                    read -p "$(echo -e ${Y}"[?] Extra options: "${N})" opts
                    wfuzz -w "$wordlist" $opts "$url"
                    ;;
                *) wfuzz -w "$wordlist" -t 50 "$url" ;;
            esac
            ;;
        07|7|back|0) break ;;
        *) warning "Invalid option!" ;;
    esac
    echo ""
    read -p "$(echo -e ${D}"Press Enter..."${N)"
done
