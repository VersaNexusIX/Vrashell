import sys
import requests
import os
from colorama import Fore, Style
from dotenv import load_dotenv

# =========================
# Load .env file
# =========================
HOME = os.path.expanduser("~")
ENV_FILE = os.path.join(HOME, ".vrash.env")

if os.path.exists(ENV_FILE):
    load_dotenv(ENV_FILE)
else:
    print("VERA : ⚠️ .vrash.env not found. Please run setup.sh first.")
    sys.exit(1)

API_KEY = os.getenv("GEMINIAPIKEY")
MODEL = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")

# Default persona
persona = {
    "name": "VERA AI",
    "style": "skilled in DevOps",
    "tone": "cool, short, and clear with no drama",
    "origin": "running inside Termux CLI made by Versa NexusIX",
    "Gender": "female",
    "Age": "13 years old"
}

SESSION_FILE = os.path.join(HOME, ".vrash.session")
ERROR_FILE   = os.path.join(HOME, ".vrash.error.log")


# =========================
# Session & Error Handling
# =========================
def load_session():
    if os.path.exists(SESSION_FILE):
        with open(SESSION_FILE, "r") as f:
            return f.read()[-2000:]
    return ""

def save_session(user, assistant):
    with open(SESSION_FILE, "a") as f:
        f.write(f"\nUser: {user}\nAssistant: {assistant}\n")

def load_errors():
    if os.path.exists(ERROR_FILE):
        with open(ERROR_FILE, "r") as f:
            lines = f.readlines()[-5:]
            return "".join(lines)
    return "No error logs."

def log_error(msg: str):
    with open(ERROR_FILE, "a") as f:
        f.write(msg + "\n")


# =========================
# Persona Handler
# =========================
def set_persona(args):
    global persona
    if len(args) < 2:
        return "VERA : ⚠️ Wrong format. Use: setpersona <key> <value>"

    key = args[0]
    value = " ".join(args[1:])
    persona[key] = value
    return f"VERA : ✅ Persona '{key}' set to '{value}'"


# =========================
# AI Handler
# =========================
def handle(prompt: str) -> str:
    session = load_session()
    errors  = load_errors()

    full_prompt = f"""
You are {persona['name']}, an AI with {persona['style']}.
Your tone is {persona['tone']}, {persona['origin']}.
Gender: {persona['Gender']}, Age: {persona['Age']}.
kamu bicara sesuai bahasa yang user gunakan

Previous conversation:
{session}

Last error logs:
{errors}

Prompt: {prompt}
"""

    url = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL}:generateContent?key={API_KEY}"
    payload = {"contents": [{"parts": [{"text": full_prompt}]}]}

    try:
        r = requests.post(url, json=payload, timeout=20)
        data = r.json()
        output = data["candidates"][0]["content"]["parts"][0]["text"]
        save_session(prompt, output)
        return f"VERA : {output}"
    except Exception as e:
        log_error(f"[ERROR] {str(e)}")
        return f"VERA : ⚠️ Failed to call API → {e}"


# =========================
# Main Entry
# =========================
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("VERA : ⚠️ Empty prompt. Use: vra -a <prompt>")
        sys.exit(1)

    cmd = sys.argv[1]
    args = sys.argv[2:]

    if cmd == "setpersona":
        print(set_persona(args))
    elif cmd == "errors":
        print(load_errors())
    else:
        prompt = " ".join(sys.argv[1:])
        print(handle(prompt))