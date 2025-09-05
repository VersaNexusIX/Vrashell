# === Setup API kalau belum ada ===
if [ ! -f ~/.vrash.env ]; then
    echo "[VRASH] Enter Gemini API"
    echo -n "API : "
    read -r api_key
    echo "export GEMINI_API_KEY=\"$api_key\"" > ~/.vrash.env
    echo "export GEMINI_MODEL=\"gemini-2.5-flash\"" >> ~/.vrash.env
    echo "[VRASH] ✅ API saved to ~/.vrash.env"
fi

# === Load environment ===
[ -f ~/.vrash.env ] && source ~/.vrash.env