#!/usr/bin/env zsh
# ~/vrash.sh 

# === Load environment ===
[ -f ~/.vrash.env ] && source ~/.vrash.env

# === Skip broken banner (uncomment next line if you want it back) ===
# [ -x ~/.termux/banner/startup.sh ] && bash ~/.termux/banner/startup.sh

# === Colors (Termux-safe) ===
autoload -U colors && colors
colors   # extra init

RED=$fg[red]; GREEN=$fg[green]; YELLOW=$fg[yellow]; CYAN=$fg[cyan]; RESET=$reset_color

# === Session & error log ===
VRASH_SESSION="$HOME/.vrash.session"
VRASH_ERROR="$HOME/.vrash.error.log"
[ ! -f "$VRASH_SESSION" ] && touch "$VRASH_SESSION"
[ ! -f "$VRASH_ERROR" ] && touch "$VRASH_ERROR"

# === Capture last command errors (keep last 5) ===
vrash_capture_error() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        local last_cmd=$(fc -ln -1) 
        echo "[ERROR $(date +"%H:%M:%S")] Code $exit_code: $last_cmd" >> "$VRASH_ERROR"
        tail -n 5 "$VRASH_ERROR" > "$VRASH_ERROR.tmp"
        mv "$VRASH_ERROR.tmp" "$VRASH_ERROR"
    fi
}

precmd_functions+=(vrash_capture_error)

# === Status prompt ===
precmd() {
    if [[ $? -eq 0 ]]; then
        CMD_STATUS="${GREEN}[ ㉿ ] success${RESET}"
    else
        CMD_STATUS="${RED}[ ㉿ ] failed${RESET}"
    fi
}
PROMPT="${RED}[%*]${RESET} ${CYAN}%~${RESET} \$CMD_STATUS ⏤͟͟͞͞ "

# === AI Function (via Python helper) ===
vra_ai() {
    python3 ~/vrash_ai.py "$@"
}

# === VRASH wrapper (unchanged) ===
vra() {
    case "$1" in
        -a)
            shift
            python3 ~/vrash_cli.py -a "$@"
            ;;
        reset-session)
            python3 ~/vrash_cli.py reset-session
            ;;
        errors)
            python3 ~/vrash_cli.py errors
            ;;
        -u)
            echo "${CYAN}[VRASH] Updating packages...${RESET}"
            pkg update -y && pkg upgrade -y
            ;;
        -I|-i)
            shift
            if [[ -z "$@" ]]; then
                echo "${RED}[VRASH] ⚠️ try: vra -i <package>${RESET}"
            else
                echo "${CYAN}[VRASH] Installing package(s): $@${RESET}"
                pkg install -y "$@"
            fi
            ;;
        -R|-r)
            shift
            if [[ -z "$@" ]]; then
                echo "${RED}[VRASH] ⚠️ try: vra -r <package>${RESET}"
            else
                echo "${CYAN}[VRASH] Removing package(s): $@${RESET}"
                pkg uninstall -y "$@"
            fi
            ;;
        -S|-s)
            shift
            if [[ -z "$@" ]]; then
                echo "${RED}[VRASH] ⚠️ try: vra -s <package>${RESET}"
            else
                echo "${CYAN}[VRASH] Searching package: $@${RESET}"
                pkg search "$@"
            fi
            ;;
        -L|-l)
            echo "${CYAN}[VRASH] Installed packages:${RESET}"
            pkg list-installed
            ;;
        -c)
            echo "${CYAN}[VRASH] Clearing Termux cache...${RESET}"
            rm -rf $PREFIX/var/cache/*
            echo "${GREEN}[VRASH] Cache cleared.${RESET}"
            ;;
        -v)
            shift
            if [[ -z "$1" ]]; then
                echo "${RED}[VRASH] ⚠️ try: vra -v <file>${RESET}"
            else
                echo "${CYAN}[VRASH] : $1${RESET}"
                nano "$@"
            fi
            ;;
        -t)
            if [[ -x ~/.termux/emotional-sync.sh ]]; then
                echo "${CYAN}[VRASH] Loading...${RESET}"
                bash ~/.termux/emotional-sync.sh
            else
                echo "${RED}[VRASH] found${RESET}"
            fi
            ;;
        -h|help|"")
            if [ -f ~/list.txt ]; then
                cat ~/list.txt | sed "s/^/${RED}/; s/\$/${RESET}/"
            else
                echo "${RED}[VRASH] No list.txt found.${RESET}"
            fi
            ;;
        *)
            if [ -f ~/list.txt ]; then
                echo "${RED}[VRASH] Unknown command: $1${RESET}"
                cat ~/list.txt | sed "s/^/${RED}/; s/\$/${RESET}/"
            else
                echo "${RED}[VRASH] Unknown command: $1${RESET}"
                echo "Usage: vra -a \"prompt\" | vra reset-session | vra errors | vra -u | vra -i <pkg> | vra -r <pkg> | vra -s <pkg> | vra -l | vra -v <file> | vra -c | vra -t"
            fi
            ;;
    esac
}
