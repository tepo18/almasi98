#!/bin/bash

# ============================================
# Script: Termux Python3 Full Auto Setup
# Author: ChatGPT
# Description: نصب خودکار Python3، کتابخانه‌ها و ابزارهای ضروری
# ============================================

# رنگ‌ها
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

echo -e "${BLUE}==== بروزرسانی مخازن و پکیج‌ها ====${RESET}"
pkg update -y && pkg upgrade -y

clean_cache() {
    echo -e "${YELLOW}پاکسازی کش و فایل‌های اضافی...${RESET}"
    pkg clean -y
    rm -rf $HOME/.cache/pip
}

# --------------------------------------------
# نصب Python 3 و کتابخانه‌ها
# --------------------------------------------
echo -e "${GREEN}==== نصب Python 3 و کتابخانه‌های کاربردی ====${RESET}"
pkg install -y python
pip install --upgrade pip
pip install requests rich colorama beautifulsoup4 lxml pandas numpy matplotlib pillow termcolor
clean_cache

# --------------------------------------------
# نصب ابزارهای پایه
# --------------------------------------------
echo -e "${GREEN}==== نصب ابزارهای پایه (git, wget, curl, nano, vim, unzip, tar) ====${RESET}"
pkg install -y git wget curl nano vim unzip tar
clean_cache

# --------------------------------------------
# فعال کردن دسترسی به حافظه داخلی
# --------------------------------------------
echo -e "${GREEN}==== فعال کردن دسترسی Termux به حافظه داخلی ====${RESET}"
termux-setup-storage

# --------------------------------------------
# نصب Node.js و npm
# --------------------------------------------
echo -e "${GREEN}==== نصب Node.js و npm ====${RESET}"
pkg install -y nodejs
npm install -g npm
clean_cache

# --------------------------------------------
# نصب ابزارهای رنگ و زیباسازی ترمینال
# --------------------------------------------
echo -e "${GREEN}==== نصب ابزارهای رنگ و زیباسازی ترمینال (figlet, toilet, rich, colorama) ====${RESET}"
pkg install -y figlet toilet
pip install rich colorama
clean_cache

echo -e "${BLUE}==== نصب تمام شد! محیط Termux آماده و بهینه است. ====${RESET}"
