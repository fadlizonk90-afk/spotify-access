@echo off
title SPOTIFY AUTO BOT - Windows Auto Setup

echo ==================================================
echo    🔧 SPOTIFY AUTO BOT - AUTO INSTALLER WINDOWS
echo ==================================================
echo Memeriksa dependensi sistem...
echo.

:: 1. Periksa Google Chrome
set "CHROME_PATH_1=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "CHROME_PATH_2=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
set "CHROME_FOUND=0"

if exist "%CHROME_PATH_1%" set "CHROME_FOUND=1"
if exist "%CHROME_PATH_2%" set "CHROME_FOUND=1"

if "%CHROME_FOUND%"=="0" (
    echo [!] Google Chrome tidak terdeteksi di lokasi standar.
    echo [!] Bot ini membutuhkan Google Chrome resmi untuk berjalan dengan aman.
    echo Membuka halaman unduhan Google Chrome...
    start https://www.google.com/chrome/
    echo.
    echo Silakan instal Google Chrome, lalu jalankan kembali file .bat ini.
    pause
    exit
) else (
    echo [✓] Google Chrome terdeteksi.
)

:: 2. Unduh spotify-bot.exe dari GitHub jika belum ada
if not exist "spotify-bot.exe" (
    echo Engine spotify-bot.exe tidak ditemukan di folder ini.
    echo Mengunduh engine dari GitHub Releases secara otomatis...
    
    :: Gunakan curl bawaan Windows 10/11 untuk download
    curl -L -o spotify-bot.exe "https://github.com/fadlizonk90-afk/spotify-access/releases/download/v1.0.0/spotify-bot.exe"
    
    if errorlevel 1 (
        echo [X] Gagal mengunduh menggunakan curl. Mencoba menggunakan PowerShell...
        powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/fadlizonk90-afk/spotify-access/releases/download/v1.0.0/spotify-bot.exe' -OutFile 'spotify-bot.exe'"
    )
)

if not exist "spotify-bot.exe" (
    echo.
    echo [X] ERROR: Gagal mengunduh atau mendeteksi file 'spotify-bot.exe'.
    echo Silakan periksa koneksi internet Anda atau download manual.
    pause
    exit
)

echo.
echo ==================================================
echo [✓] Semua persyaratan terpenuhi!
echo [!] Memulai setup Aktivasi Lisensi Bot...
echo ==================================================
echo.

:: 3. Jalankan bot
spotify-bot.exe

pause
