#!/usr/bin/env bash
# KALI-ELITE - Full Automated Scan
# Usage: ./full-scan.sh <target>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/colors.sh"

TARGET="$1"
[ -z "$TARGET" ] && read -p "$(echo -e ${Y}"[?] Target IP/Domain: "${N})" TARGET
[ -z "$TARGET" ] && { error "Target required!"; exit 1; }

REPORT_DIR="$HOME/kali-elite/reports/full_scan_${TARGET}_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$REPORT_DIR"

clear
echo -e "${R}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              ⚡ KALI-ELITE FULL SCAN ⚡                 ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${N}"
echo -e "  ${C}Target:${N} ${Y}${TARGET}${N}"
echo -e "  ${C}Date:${N}  ${Y}$(date)${N}"
echo -e "  ${C}Output:${N} ${G}${REPORT_DIR}/${N}"
echo ""

# Phase 1: Nmap
header "PHASE 1: PORT SCAN" $G
echo -e "${R}[${Y}1/5${R}]${N} ${G}Nmap - Service detection...${N}"
sudo nmap -sC -sV -T4 "$TARGET" -oN "$REPORT_DIR/01_nmap_services.txt" 2>/dev/null
echo -e "  ${G}✓${N} Saved"

echo -e "${R}[${Y}2/5${R}]${N} ${G}Nmap - Full port scan...${N}"
sudo nmap -p- --min-rate=1000 "$TARGET" -oN "$REPORT_DIR/02_nmap_allports.txt" 2>/dev/null
echo -e "  ${G}✓${N} Saved"

# Phase 2: Vulnerability
header "PHASE 2: VULNERABILITY SCAN" $Y
echo -e "${R}[${Y}3/5${R}]${N} ${Y}Nuclei - Template scan...${N}"
nuclei -u "http://$TARGET" -severity low,medium,high,critical -o "$REPORT_DIR/03_nuclei.txt" 2>/dev/null || \
nuclei -u "https://$TARGET" -severity low,medium,high,critical -o "$REPORT_DIR/03_nuclei.txt" 2>/dev/null || \
echo -e "  ${Y}⚠${N} Nuclei skipped (no web or not installed)"
echo -e "  ${G}✓${N} Saved"

# Phase 3: Web
header "PHASE 3: WEB ANALYSIS" $B
echo -e "${R}[${Y}4/5${R}]${N} ${B}WhatWeb - Tech detection...${N}"
whatweb "$TARGET" -v > "$REPORT_DIR/04_whatweb.txt" 2>/dev/null
echo -e "  ${G}✓${N} Saved"

echo -e "${R}[${Y}5/5${R}]${N} ${B}Nikto - Web server scan...${N}"
nikto -h "$TARGET" -o "$REPORT_DIR/05_nikto.txt" 2>/dev/null
echo -e "  ${G}✓${N} Saved"

# Summary
header "SCAN COMPLETE" $G
echo -e "  ${C}Target:${N}  ${Y}${TARGET}${N}"
echo -e "  ${C}Reports:${N} ${G}${REPORT_DIR}/${N}"
echo ""
echo -e "${C}Files generated:${N}"
ls -1 "$REPORT_DIR/" 2>/dev/null | while read f; do
    size=$(du -h "$REPORT_DIR/$f" 2>/dev/null | cut -f1)
    echo -e "  ${G}→${N} ${Y}$f${N} ${D}(${size})${N}"
done
echo ""
echo -e "${Y}Use 'kali-elite report' to generate a pentest report.${N}"
