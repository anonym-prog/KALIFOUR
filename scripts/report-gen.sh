#!/usr/bin/env bash
# KALI-ELITE - Report Generator

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/colors.sh"

REPORT_DIR="$HOME/kali-elite/reports"

header "📊 PENTEST REPORT GENERATOR" $C

echo -e "  ${R}[${Y}1${R}]${N} ${G}Generate Summary${N}  ${D}— Markdown summary of all scans${N}"
echo -e "  ${R}[${Y}2${R}]${N} ${G}List Reports${N}     ${D}— Show all saved reports${N}"
echo -e "  ${R}[${Y}3${R}]${N} ${G}Export All${N}       ${D}— Combine all reports into one file${N}"
echo -e "  ${R}[${Y}4${R}]${N} ${G}Clean Old${N}        ${D}— Delete reports older than 7 days${N}"
echo -e "  ${R}[${Y}00${R}]${N} ${Y}Back${N}"
echo ""
read -p "$(echo -e ${C}"[${Y}REPORT${C}]${N} > ")" ch

case $ch in
    1|summary)
        local summary="$REPORT_DIR/pentest_summary_$(date +%Y%m%d).md"
        {
            echo "# KALI-ELITE Pentest Summary"
            echo "**Date:** $(date)"
            echo "**Host:** $(hostname)"
            echo ""
            echo "## Scan Reports"
            echo ""
            find "$REPORT_DIR" -type f -name "*.txt" -mtime -1 2>/dev/null | while read f; do
                lines=$(wc -l < "$f")
                issues=$(grep -ciE '(vulnerability|critical|high|open|found|warning)' "$f" 2>/dev/null)
                echo "- $(basename $f): $lines lines, $issues findings"
            done
            echo ""
            echo "## Tools Available"
            for tool in nmap nuclei metasploit sqlmap hydra john hashcat bettercap burpsuite; do
                command -v "$tool" &>/dev/null && echo "- $tool: installed"
            done
        } > "$summary"
        success "Summary saved: $summary"
        cat "$summary"
        ;;
    2|list)
        echo -e "${C}Reports in ${G}${REPORT_DIR}${N}:"
        find "$REPORT_DIR" -type f 2>/dev/null | sort -r | while read f; do
            size=$(du -h "$f" 2>/dev/null | cut -f1)
            date_modified=$(stat -c "%y" "$f" 2>/dev/null | cut -d. -f1)
            echo -e "  ${G}→${N} ${Y}$(basename $f)${N} ${D}(${size}, ${date_modified})${N}"
        done | head -30
        ;;
    3|export)
        local export_file="$REPORT_DIR/full_export_$(date +%Y%m%d).txt"
        {
            echo "=========================================="
            echo "KALI-ELITE COMPLETE REPORT EXPORT"
            echo "Date: $(date)"
            echo "Host: $(hostname)"
            echo "=========================================="
            echo ""
            find "$REPORT_DIR" -type f -name "*.txt" 2>/dev/null | while read f; do
                echo "------------------------------------------"
                echo "FILE: $(basename $f)"
                echo "------------------------------------------"
                cat "$f" 2>/dev/null | head -200
                echo -e "\n... (truncated at 200 lines)\n"
            done
        } > "$export_file"
        success "Exported: $export_file ($(du -h "$export_file" | cut -f1))"
        ;;
    4|clean)
        confirm "Delete reports older than 7 days?" && {
            find "$REPORT_DIR" -type f -mtime +7 -delete 2>/dev/null
            success "Old reports cleaned!"
        }
        ;;
    00|0) exit 0 ;;
esac
