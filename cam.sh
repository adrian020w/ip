#!/bin/bash
# Lacak IP Privat / Lokal
# Banner LisungHack
banner() {
echo -e "\e[1;92m"
echo " _      _____  _   _ _   _ _   _ _  __ _    _  _  _  _ "
echo "| |    |  ___|| | | | \ | | | | | |/ /| |  | || || || |"
echo "| |    | |_   | | | |  \| | | | | ' / | |  | || || || |"
echo "| |___ |  _|  | |_| | |\  | |_| | . \ | |__| || || || |"
echo "|____/ |_|     \___/|_| \_|\___/|_|\_\ \____/|_|_|_|_|"
echo -e "\e[0m"
echo -e "\e[1;93m                  by LisungHack\e[0m"
echo "---------------------------------------------------------"
}

banner

echo "[*] Informasi IP Privat / Lokal"

# Dapatkan IP lokal
echo -e "\nIP Address Lokal:"
hostname -I

# Info interface aktif
echo -e "\nInterface Aktif:"
ip addr show | grep "state UP" -A2

# Gateway default
echo -e "\nGateway Default:"
ip route | grep default

# Nama host & OS
echo -e "\nNama Host: $(hostname)"
echo "OS: $(uname -a)"

# Simpan ke file ip_lokal.txt
{
echo "Tanggal: $(date '+%Y-%m-%d %H:%M:%S')"
echo "IP Address: $(hostname -I)"
echo "Gateway: $(ip route | grep default)"
echo "Host: $(hostname)"
echo "OS: $(uname -a)"
echo "---------------------------"
} >> ip_lokal.txt

echo -e "\n[*] Hasil disimpan di ip_lokal.txt"
