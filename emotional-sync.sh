#!/data/data/com.termux/files/usr/bin/bash

MOOD="$1"
FONT_DIR="$HOME/.termux/fonts"
THEME_DIR="$HOME/.termux/themes"
TERMUX_DIR="$HOME/.termux"

sync_mood() {
  case "$MOOD" in
    "peaceful")
      cp "$FONT_DIR/Ubuntu.ttf" "$TERMUX_DIR/font.ttf"
      cp "$THEME_DIR/peaceful.colors" "$TERMUX_DIR/colors.properties"
      ;;
    "chaotic")
      cp "$FONT_DIR/Hack-Bold.ttf" "$TERMUX_DIR/font.ttf"
      cp "$THEME_DIR/chaotic.colors" "$TERMUX_DIR/colors.properties"
      ;;
    "teasing")
      cp "$FONT_DIR/Ubuntu.ttf" "$TERMUX_DIR/font.ttf"
      cp "$THEME_DIR/teasing.colors" "$TERMUX_DIR/colors.properties"
      ;;
    *)
      echo "❌ Theme '$MOOD' Not Found."
      exit 1
      ;;
  esac

  termux-reload-settings
  echo " Theme Slected '$MOOD'."
}

# Interaktif prompt kalau nggak ada argumen
if [ -z "$MOOD" ]; then
  echo ""
  echo " Select Theme"
  echo "Pilih mood:"
  echo "1. peaceful"
  echo "2. chaotic"
  echo "3. teasing"
  echo "4. cancel"
  echo ""

  read -p "➣ Chose (1-4): " choice

  case "$choice" in
    1) MOOD="peaceful" ;;
    2) MOOD="chaotic" ;;
    3) MOOD="teasing" ;;
    4)
      echo "❎ canceled."
      exit 0
      ;;
    *)
      echo "❌ Not a valid"
      exit 1
      ;;
  esac
fi

# Panggil fungsi sync
sync_mood
