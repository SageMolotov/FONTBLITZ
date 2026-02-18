# ⚡ FontBlitz

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-lightgrey.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)

### Batch Font Installer for Windows — by Sage Molotov + Claude AI

---

## What Is FontBlitz?

FontBlitz is a free PowerShell script that rips through folders of zipped fonts, intelligently detects which ZIPs actually contain font files (even inside nested ZIPs), extracts only what matters, and installs everything to Windows in one shot.

Built for designers, DJs, VJs, and creatives who download massive font packs and don't want to spend an hour unzipping and installing one by one.

**Works with:** Adobe Creative Cloud, DaVinci Resolve, OBS, Canva Desktop, Microsoft Office, and any app that reads Windows system fonts.

---

## Features

- **Deep-Scan Technology** — Peeks inside nested ZIPs (up to 5 levels deep) *in memory* without extracting, so non-font ZIPs are never touched
- **Smart Detection** — Only extracts ZIPs confirmed to contain .ttf or .otf files
- **Batch Install** — Copies fonts to Windows system directory and registers them in the registry automatically
- **Skip Duplicates** — Already installed? It skips them. No bloat, no conflicts
- **Auto-Elevate** — Requests administrator access automatically when needed
- **Full Logging** — Saves a detailed log file so you know exactly what happened
- **Zero Data Collection** — This script runs 100% locally. No internet connection, no telemetry, no tracking. Your files never leave your machine. Period.

---

## Requirements

- Windows 10 or 11
- PowerShell 5.1+ (pre-installed on all modern Windows machines)
- Administrator access (the script will prompt you automatically)

---

## Quick Start (3 Steps)

### Step 1: Edit the Script Path

Open `FontBlitz.ps1` in any text editor (right-click → "Edit" or open in Notepad).

Find the line near the top:

```powershell
$FontFolder = "C:\PUT\YOUR\FONT\FOLDER\PATH\HERE"
```

Change the path inside the quotes to wherever YOUR zipped font files are. For example:

```
$FontFolder = "C:\Users\YourName\Downloads\My Fonts"
```

Save the file.

### Step 2: Run the Script

**Option A — Simple (works most of the time):**
Right-click `FontBlitz.ps1` → **"Run with PowerShell"**

**Option B — If the window flashes and closes immediately:**
This means Windows blocked the script. No worries — do this instead:

1. Right-click the **Start Menu** → click **"Terminal (Admin)"** or search for **PowerShell** and select **"Run as Administrator"**
2. Paste the following (update the path to where you saved FontBlitz):

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
& "C:\Users\YourName\Downloads\FontBlitz.ps1"
```

3. Press Enter and let it run.

### Step 3: Restart Your Apps

Close and reopen any Adobe CC apps (Photoshop, Illustrator, Premiere, After Effects, etc.) to see your new fonts.

That's it. You're done.

---

## What the Output Means

After running, you'll see a summary like this:

```
============================================
  COMPLETE
============================================
  Fonts installed   : 847
  Fonts skipped     : 203 (already installed)
  Fonts failed      : 0

  ZIPs extracted    : 52 (fonts confirmed inside)
  ZIPs skipped      : 3 (no fonts - untouched)
  ZIPs unreadable   : 1 (see details above)

  Log saved to: C:\Your\Font\Folder\font-install-log.txt
============================================
```

| Line | Meaning |
|------|---------|
| **Fonts installed** | New fonts successfully added to Windows |
| **Fonts skipped** | Fonts that were already installed — no action needed |
| **Fonts failed** | Fonts that couldn't be installed (check the log for details) |
| **ZIPs extracted** | ZIP files that contained fonts and were unpacked |
| **ZIPs skipped** | ZIP files with no fonts inside — left completely untouched |
| **ZIPs unreadable** | Corrupt or password-protected ZIPs that couldn't be opened |

A full log is saved to your font folder as `font-install-log.txt`.

---

## Troubleshooting

**The PowerShell window flashes and closes instantly**
→ Windows execution policy is blocking it. Use Option B in Step 2 above.

**"Font folder not found" error**
→ Double-check the path in the script. Make sure it matches your actual folder location, including any spaces in the name.

**Fonts don't show up in Adobe apps**
→ Close and fully reopen the Adobe app (not just the file — quit and relaunch the app). Adobe only loads fonts on startup.

**"Access denied" or permission errors**
→ Make sure you're running as Administrator. The script tries to auto-elevate, but if that fails, use Option B in Step 2.

**Some ZIPs marked as "unreadable"**
→ These are either corrupt downloads or password-protected archives. Try re-downloading them or check if the source provided a password.

---

## Your Data Stays Yours 🔒

FontBlitz is a local-only script. It:

- ❌ Does NOT connect to the internet
- ❌ Does NOT collect any data
- ❌ Does NOT phone home, track usage, or send telemetry
- ❌ Does NOT require an account or registration
- ✅ Runs entirely on your machine
- ✅ You can read every line of code yourself — it's all right there

---

## Installation

**Download the latest release:**
1. Go to [Releases](https://github.com/SageMolotov/FontBlitz/releases)
2. Download `FontBlitz.ps1`
3. Follow the Quick Start guide above

**Or clone the repository:**
```bash
git clone https://github.com/SageMolotov/FontBlitz.git
cd FontBlitz
```

---

## Contributing

Want to improve FontBlitz? Check out [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

FontBlitz is released under the [MIT License](LICENSE). Free to use, free to share.

---

## About

**FontBlitz** was built by [Sage Molotov](https://sagemolotov.com) + Claude AI as a free tool for the creative community.

If this saved you time, consider following the journey:

- 🌐 [sagemolotov.com](https://sagemolotov.com)
- 📸 [Instagram](https://instagram.com/sagemolotov)
- 🎵 [SoundCloud](https://soundcloud.com/sagemolotov)
- 🎥 [YouTube](https://youtube.com/@sagemolotov)
- 🎧 [Patreon](https://patreon.com/sagemolotov)

---

*FontBlitz v1.0.0 — © 2026 Sage Molotov*
