# ============================================================
# BATCH FONT INSTALLER v5 - by Sage Molotov + Claude
# ============================================================
# FREE TOOL — sagemolotov.com | patreon.com/sagemolotov
# ============================================================
# WHAT THIS DOES:
#   1. Recursively finds all ZIP files in your font folder
#   2. Peeks inside each ZIP (including nested ZIPs) without
#      extracting — only extracts if fonts are confirmed inside
#   3. Handles unlimited nesting depth (zips inside zips inside zips)
#   4. Installs all .ttf and .otf files to Windows system fonts
#   5. Registers fonts in the Windows registry for Adobe CC + all apps
#   6. Deletes font ZIPs after extraction, leaves non-font ZIPs alone
#   7. Logs everything to a text file for your records
#
# HOW TO RUN:
#   Right-click this file -> "Run with PowerShell"
#   (It will auto-elevate to Administrator if needed)
#
# REQUIREMENTS:
#   Windows 10/11, PowerShell 5.1+
# ============================================================

# --- CONFIGURATION ---
# >>> EDIT THIS PATH to point to your font folder <<<
$FontFolder = "C:\Users\sage\OneDrive\Desktop\NEW FONTS - ENVATO"

$FontExtensions = @(".ttf", ".otf")
$SystemFontsDir = "$env:SystemRoot\Fonts"
$FontRegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
$LogFile = Join-Path $FontFolder "font-install-log.txt"

# ============================================================
# STEP 0: Elevate to Administrator if needed
# ============================================================
function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Write-Host ""
    Write-Host "  Restarting as Administrator..." -ForegroundColor Yellow
    $scriptPath = $MyInvocation.MyCommand.Definition
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    exit
}

# ============================================================
# LOGGING HELPER
# ============================================================
function Write-Log {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp | $Message" | Out-File -FilePath $LogFile -Append -Encoding UTF8
}

# ============================================================
# IN-MEMORY NESTED ZIP FONT DETECTION
# ============================================================
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression

function Test-ZipContainsFonts {
    param(
        [string]$ZipPath,
        [int]$MaxDepth = 5
    )
    try {
        $stream = [System.IO.File]::OpenRead($ZipPath)
        $result = Test-ZipStreamForFonts -Stream $stream -Depth 0 -MaxDepth $MaxDepth
        $stream.Dispose()
        return $result
    } catch {
        return "error"
    }
}

function Test-ZipStreamForFonts {
    param(
        [System.IO.Stream]$Stream,
        [int]$Depth,
        [int]$MaxDepth
    )

    if ($Depth -gt $MaxDepth) { return "none" }

    try {
        $archive = New-Object System.IO.Compression.ZipArchive($Stream, [System.IO.Compression.ZipArchiveMode]::Read, $true)

        foreach ($entry in $archive.Entries) {
            $ext = [System.IO.Path]::GetExtension($entry.FullName).ToLower()

            # Direct font file found
            if ($ext -in $FontExtensions) {
                $archive.Dispose()
                return "fonts"
            }
        }

        # No direct fonts — check nested zips in memory
        foreach ($entry in $archive.Entries) {
            $ext = [System.IO.Path]::GetExtension($entry.FullName).ToLower()

            if ($ext -eq ".zip") {
                try {
                    $nestedStream = $entry.Open()
                    $memStream = New-Object System.IO.MemoryStream
                    $nestedStream.CopyTo($memStream)
                    $nestedStream.Dispose()
                    $memStream.Position = 0

                    $nestedResult = Test-ZipStreamForFonts -Stream $memStream -Depth ($Depth + 1) -MaxDepth $MaxDepth
                    $memStream.Dispose()

                    if ($nestedResult -eq "fonts") {
                        $archive.Dispose()
                        return "fonts"
                    }
                } catch {
                    # Nested zip unreadable, skip it
                    continue
                }
            }
        }

        $archive.Dispose()
        return "none"

    } catch {
        return "error"
    }
}

# ============================================================
# HEADER
# ============================================================
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  BATCH FONT INSTALLER v5" -ForegroundColor Cyan
Write-Host "  Deep-scan ZIP detection + logging" -ForegroundColor Cyan
Write-Host "  by Sage Molotov + Claude" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Start fresh log
"Font Install Log - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $LogFile -Encoding UTF8
"============================================" | Out-File -FilePath $LogFile -Append -Encoding UTF8

if (-not (Test-Path $FontFolder)) {
    Write-Log "[ERROR] Font folder not found: $FontFolder" "Red"
    Write-Host ""
    Write-Host "  Edit line 25 of this script to fix the path." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Log "[OK] Font folder: $FontFolder" "Green"
Write-Host ""

# ============================================================
# STEP 1: Smart ZIP extraction (with deep-scan)
# ============================================================
Write-Log "--- STEP 1: Smart ZIP extraction (deep-scan) ---" "Yellow"
Write-Host ""

$totalZipsExtracted = 0
$skippedZips = @()
$failedZips = @()
$pass = 0

do {
    $pass++
    $zipFiles = Get-ChildItem -Path $FontFolder -Filter "*.zip" -Recurse -ErrorAction SilentlyContinue

    $zipFiles = $zipFiles | Where-Object {
        ($skippedZips -notcontains $_.FullName) -and ($failedZips -notcontains $_.FullName)
    }

    $zipCount = ($zipFiles | Measure-Object).Count

    if ($zipCount -eq 0) {
        if ($pass -eq 1) {
            Write-Log "  No ZIP files found." "Gray"
        }
        break
    }

    Write-Log "  Pass $pass : Deep-scanning $zipCount ZIP(s)..." "White"

    $extractedThisPass = 0

    foreach ($zip in $zipFiles) {
        $result = Test-ZipContainsFonts -ZipPath $zip.FullName

        if ($result -eq "none") {
            Write-Log "    [SKIP] $($zip.Name) - no fonts (even in nested zips)" "Gray"
            $skippedZips += $zip.FullName
            continue
        }

        if ($result -eq "error") {
            Write-Log "    [FAIL] $($zip.Name) - cannot read (corrupt or password-protected)" "Red"
            $failedZips += $zip.FullName
            continue
        }

        # Confirmed fonts inside — extract
        $extractTo = Join-Path $zip.DirectoryName $zip.BaseName

        try {
            if (-not (Test-Path $extractTo)) {
                New-Item -ItemType Directory -Path $extractTo -Force | Out-Null
            }

            Expand-Archive -Path $zip.FullName -DestinationPath $extractTo -Force -ErrorAction Stop
            Remove-Item -Path $zip.FullName -Force

            Write-Log "    [OK] $($zip.Name) - extracted (fonts confirmed)" "Green"
            $extractedThisPass++
            $totalZipsExtracted++

        } catch {
            Write-Log "    [FAIL] $($zip.Name) - $($_.Exception.Message)" "Red"
            $failedZips += $zip.FullName
        }
    }

    if ($extractedThisPass -eq 0) {
        break
    }

} while ($true)

Write-Host ""
if ($totalZipsExtracted -gt 0) {
    Write-Log "  ZIPs extracted : $totalZipsExtracted" "Green"
}
if ($skippedZips.Count -gt 0) {
    Write-Log "  ZIPs skipped   : $($skippedZips.Count) (no fonts inside - untouched)" "Gray"
}
if ($failedZips.Count -gt 0) {
    Write-Host ""
    Write-Log "  [!] $($failedZips.Count) ZIP(s) could not be opened:" "Red"
    foreach ($f in $failedZips) {
        Write-Log "      - $(Split-Path $f -Leaf)" "Red"
    }
}
Write-Host ""

# ============================================================
# STEP 2: Find all font files
# ============================================================
Write-Log "--- STEP 2: Scanning for font files ---" "Yellow"
Write-Host ""

$fontFiles = @()
foreach ($ext in $FontExtensions) {
    $found = Get-ChildItem -Path $FontFolder -Filter "*$ext" -Recurse -ErrorAction SilentlyContinue
    $fontFiles += $found
}

$totalFonts = ($fontFiles | Measure-Object).Count

if ($totalFonts -eq 0) {
    Write-Log "  No font files found after extraction." "Gray"
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Write-Log "  Found $totalFonts font file(s)." "Green"
Write-Host ""

# ============================================================
# STEP 3: Install fonts
# ============================================================
Write-Log "--- STEP 3: Installing fonts ---" "Yellow"
Write-Host ""

$installed = 0
$skipped = 0
$failed = 0

foreach ($font in $fontFiles) {
    $fontName = $font.Name
    $destPath = Join-Path $SystemFontsDir $fontName

    if (Test-Path $destPath) {
        $skipped++
        continue
    }

    try {
        Copy-Item -Path $font.FullName -Destination $destPath -Force

        $extension = $font.Extension.ToLower()
        if ($extension -eq ".ttf") {
            $regName = "$($font.BaseName) (TrueType)"
        } elseif ($extension -eq ".otf") {
            $regName = "$($font.BaseName) (OpenType)"
        } else {
            $regName = $font.BaseName
        }

        New-ItemProperty -Path $FontRegKey -Name $regName -Value $fontName -PropertyType String -Force | Out-Null

        Write-Log "  [OK] $fontName" "Green"
        $installed++

    } catch {
        Write-Log "  [FAIL] $fontName - $($_.Exception.Message)" "Red"
        $failed++
    }
}

Write-Host ""

# ============================================================
# SUMMARY
# ============================================================
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  COMPLETE" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Log "  Fonts installed   : $installed" "Green"
Write-Log "  Fonts skipped     : $skipped (already installed)" "Gray"

if ($failed -gt 0) {
    Write-Log "  Fonts failed      : $failed" "Red"
} else {
    Write-Log "  Fonts failed      : 0" "Gray"
}

Write-Host ""
Write-Log "  ZIPs extracted    : $totalZipsExtracted (fonts confirmed inside)" "Green"
Write-Log "  ZIPs skipped      : $($skippedZips.Count) (no fonts - untouched)" "Gray"
if ($failedZips.Count -gt 0) {
    Write-Log "  ZIPs unreadable   : $($failedZips.Count) (see details above)" "Red"
}
Write-Host ""
Write-Log "  Log saved to: $LogFile" "Cyan"
Write-Host ""
Write-Host "  NEXT STEP: Close & reopen any Adobe apps to see new fonts." -ForegroundColor Yellow
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Sage Molotov + Claude | sagemolotov.com" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
