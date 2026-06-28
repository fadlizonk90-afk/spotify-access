#!/bin/bash

# ==============================================================================
#          🎧 SPOTIFY AUTO BOT - AUTO INSTALLER FOR LINUX (VPS) 🎧
# ==============================================================================

# Warna output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}==================================================${NC}"
echo -e "${GREEN}   🔧 SPOTIFY AUTO BOT - AUTO INSTALLER LINUX${NC}"
echo -e "${CYAN}==================================================${NC}"
echo -e "${YELLOW}Memulai instalasi otomatis dependensi...${NC}"
echo ""

# 1. Update package list
echo -e "${CYAN}[1/5] Memperbarui paket sistem...${NC}"
sudo apt update -y && sudo apt upgrade -y

# 2. Install dependencies
echo -e "${CYAN}[2/5] Menginstal dependensi sistem yang dibutuhkan...${NC}"
sudo apt install -y wget curl unzip libgbm1 libasound2 libatk-bridge2.0-0 libgtk-3-0

# 3. Download & Install Google Chrome
echo -e "${CYAN}[3/5] Mengunduh dan menginstal Google Chrome Stable...${NC}"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -f -y
rm google-chrome-stable_current_amd64.deb

# 4. Install Node.js & PM2
echo -e "${CYAN}[4/5] Menginstal Node.js V18 dan PM2...${NC}"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi
if ! command -v pm2 &> /dev/null; then
    sudo npm install pm2 -g
fi

# 5. Download & Make bot executable
echo -e "${CYAN}[5/5] Mengunduh dan mengatur izin eksekusi bot...${NC}"
if [ ! -f "./spotify-bot-linux" ]; then
    echo -e "${YELLOW}Mengunduh engine spotify-bot-linux otomatis dari GitHub...${NC}"
    wget -O spotify-bot-linux https://github.com/fadlizonk90-afk/spotify-access/releases/download/v1.0.0/spotify-bot-linux
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Gagal mengunduh engine spotify-bot-linux! Periksa koneksi internet VPS Anda.${NC}"
        exit 1
    fi
fi
chmod +x spotify-bot-linux

echo -e "${GREEN}✅ Semua dependensi berhasil diinstal!${NC}"
echo -e "${CYAN}==================================================${NC}"
echo -e "${YELLOW}👉 MEMULAI SETUP AKTIVASI LISENSI BOT...${NC}"
echo -e "${CYAN}==================================================${NC}"
echo -e "Silakan masukkan data yang diminta di bawah ini."
echo ""

# Jalankan bot secara langsung (interactive) agar user memasukkan token, ID, dan lisensi
./spotify-bot-linux

# Periksa apakah config.json sukses terbuat
if [ -f "./config.json" ]; then
    echo ""
    echo -e "${GREEN}✅ Aktivasi Sukses! Konfigurasi tersimpan.${NC}"
    echo -e "${YELLOW}Menjalankan bot di background menggunakan PM2...${NC}"
    
    # Hentikan proses lama jika ada
    pm2 stop spotify-bot &> /dev/null
    pm2 delete spotify-bot &> /dev/null
    
    # Jalankan bot di PM2
    pm2 start ./spotify-bot-linux --name "spotify-bot"
    pm2 save
    pm2 startup
    
    echo -e "${CYAN}==================================================${NC}"
    echo -e "${GREEN}🎉 CONGRATULATIONS! BOT TELAH AKTIF DI BACKGROUND!${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo -e "• Status PM2: ${GREEN}Online${NC}"
    echo -e "• Untuk melihat log aktif: ${YELLOW}pm2 logs spotify-bot${NC}"
    echo -e "• Untuk mematikan bot: ${YELLOW}pm2 stop spotify-bot${NC}"
    echo -e "• Untuk menyalakan kembali: ${YELLOW}pm2 start spotify-bot${NC}"
    echo -e "${CYAN}==================================================${NC}"
else
    echo -e "${RED}❌ Setup dibatalkan atau aktivasi lisensi gagal!${NC}"
    echo -e "${YELLOW}Silakan jalankan kembali './bot.sh' setelah mendapatkan Kunci Aktivasi yang valid.${NC}"
fi
