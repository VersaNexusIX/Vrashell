#!/data/data/com.termux/files/usr/bin/bash

# Cek apakah banner sudah pernah ditampilkan di sesi ini
if [[ -n "$BANNER_SHOWN" ]]; then
  return
fi
export BANNER_SHOWN=1

RED='\033[1;31m'
RESET='\033[0m'

DEV="Versa NexusIX"
OS=$(uname -o)
STORAGE=$(df -h /data | awk 'NR==2 {print $4}')
TIME=$(date +"%A, %d %B %Y — %H:%M")
KERNEL=$(uname -r)

ascii_art=(
"⢀⠤⠤⢄⡀      ⢀⠤⠒⠒⢤         ╭────────────────────────────╮"
" ⠏   ⠈⠳⡄  ⡠⠚⠁   ⠘⡄       │ Dev name : $DEV"
"⢸   ⠤⣤⣤⡆ ⠈⣱⣤⣴⡄   ⡇       │ OS       : $OS"
"⠘⡀    ⢈⣷⠤⠴⢺⣀    ⢀⡇       │ Storage  : $STORAGE"
" ⠡⣀⣀⣤⠶⠻⡏  ⢸⡟⠙⣶⡤⠤⠼        │ Jam      : $TIME"
"  ⢠⡾⠉ ⢠⡆  ⢸⠃ ⠈⢻⣆         │ Kernel   : $KERNEL"
"  ⣿⣠⢶⣄ ⡇  ⠘⠃⣀⡤⢌⣈⡀        ╰────────────────────────────╯"
"     ⠙⠼    ⠿⠋"
)

print_red_art() {
  for line in "${ascii_art[@]}"; do
    echo -e "${RED}${line}${RESET}"
  done
}

loading_bar() {
  local bar_length=30
  local pos=0
  local duration=30  # 3 detik (30 * 0.1s)
  for ((i=0; i<duration; i++)); do
    echo -ne "\r"
    # Buat bar kosong dengan spasi
    bar=$(printf '%*s' "$bar_length" '')
    # Ganti posisi pos dengan '='
    bar="${bar:0:pos}=${bar:pos+1}"
    echo -ne "${RED}${bar}${RESET}"
    ((pos++))
    if (( pos >= bar_length )); then
      pos=0
    fi
    sleep 0.1
  done
  # Bersihkan bar setelah selesai
  echo -ne "\r$(printf '%*s' $bar_length '')\r"
}

clear
echo -e "\n"
echo -ne "${RED}Injecting expressive kernel"
for i in {1..3}; do
  echo -ne "."
  sleep 0.4
done
echo -e "${RESET}\n"

print_red_art
echo ""
loading_bar
echo ""
