#!/usr/bin/env bash
# KALI-ELITE - Color Configuration

# ANSI Colors
R='\033[1;31m'    # Red
G='\033[1;32m'    # Green
Y='\033[1;33m'    # Yellow
B='\033[1;34m'    # Blue
P='\033[1;35m'    # Purple
C='\033[1;36m'    # Cyan
W='\033[1;37m'    # White
N='\033[0m'       # Reset
D='\033[2m'       # Dim
BD='\033[1m'       # Bold
UL='\033[4m'       # Underline
BL='\033[5m'       # Blink

# Backgrounds
BG_R='\033[41m'
BG_G='\033[42m'
BG_Y='\033[43m'
BG_B='\033[44m'
BG_P='\033[45m'
BG_C='\033[46m'

# Icons
CHECK="${G}✓${N}"
CROSS="${R}✗${N}"
WARN="${Y}⚠${N}"
ARROW="${C}→${N}"
BOLT="${Y}⚡${N}"
SKULL="${R}💀${N}"
SHIELD="${G}🛡${N}"
TARGET="${R}🎯${N}"
GEAR="${G}⚙${N}"
STAR="${Y}★${N}"
LOCK="${Y}🔒${N}"
GLOBE="${C}🌐${N}"
FIRE="${R}🔥${N}"
KEY="${P}🔑${N}"
WIFI_SIGNAL="${C}📶${N}"
EYE="${C}👁${N}"

# Functions
header() {
    local title="$1"
    local color="${2:-$R}"
    echo ""
    echo -e "${color}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${color}║${N}  ${Y}${BD}◆${N} ${W}${BD}${title}${N} ${Y}${BD}◆${N}"
    echo -e "${color}╚══════════════════════════════════════════════════════════╝${N}"
    echo ""
}

success() { echo -e " ${G}[${CHECK}]${N} ${1}"; }
error() { echo -e " ${R}[${CROSS}]${N} ${1}"; }
warning() { echo -e " ${Y}[${WARN}]${N} ${1}"; }
info() { echo -e " ${C}[${ARROW}]${N} ${1}"; }

tool_banner() {
    local name="$1"
    local category="$2"
    local color="${3:-$R}"
    echo ""
    echo -e "${color}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${color}║${N} ${Y}${BOLT}${N} ${W}${BD}${name}${N} ${D}(${category})${N}"
    echo -e "${color}╚══════════════════════════════════════════════════════════╝${N}"
    echo ""
}

confirm() {
    local prompt="$1"
    local yn
    read -p "$(echo -e ${Y}"[?] ${prompt} [y/N]: "${N})" yn
    case "$yn" in [Yy]*) return 0 ;; *) return 1 ;; esac
}

progress_bar() {
    local current="$1"
    local total="$2"
    local width=40
    local pct=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r${Y}[${N}"
    for ((i=0; i<filled; i++)); do printf "${G}█${N}"; done
    for ((i=0; i<empty; i++)); do printf "${R}░${N}"; done
    printf "${Y}]${N} ${G}%d%%${N} ${D}(%d/%d)${N}" "$pct" "$current" "$total"
}

# Export all variables
export R G Y B P C W N D BD UL BL
export BG_R BG_G BG_Y BG_B BG_P BG_C
export CHECK CROSS WARN ARROW BOLT SKULL SHIELD TARGET GEAR STAR LOCK GLOBE FIRE KEY WIFI_SIGNAL EYE
