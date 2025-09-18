#!/bin/bash
# Lacak IP dan simpan hasil ke ip.txt
# Versi dengan banner LisungHack

# Fungsi banner
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

read -p "Masukkan IP yang ingin dilacak (Enter = IP publik): " IP

# Kalau kosong, pakai IP publik mesin sendiri
if [[ -z "$IP" ]]; then
    IP=$(curl -s https://api.ipify.org)
fi

# Ambil info lokasi dari ip-api.com
DATA=$(curl -s "http://ip-api.com/json/$IP")

STATUS=$(echo "$DATA" | grep -o '"status":"[^"]*' | cut -d'"' -f4)

if [[ "$STATUS" == "success" ]]; then
    COUNTRY=$(echo "$DATA" | grep -o '"country":"[^"]*' | cut -d'"' -f4)
    REGION=$(echo "$DATA" | grep -o '"regionName":"[^"]*' | cut -d'"' -f4)
    CITY=$(echo "$DATA" | grep -o '"city":"[^"]*' | cut -d'"' -f4)
    ZIP=$(echo "$DATA" | grep -o '"zip":"[^"]*' | cut -d'"' -f4)
    LAT=$(echo "$DATA" | grep -o '"lat":[^,]*' | cut -d':' -f2)
    LON=$(echo "$DATA" | grep -o '"lon":[^,]*' | cut -d':' -f2)
    ISP=$(echo "$DATA" | grep -o '"isp":"[^"]*' | cut -d'"' -f4)

    # Tampilkan di terminal
    echo "IP: $IP"
    echo "Negara: $COUNTRY"
    echo "Region: $REGION"
    echo "Kota: $CITY"
    echo "ZIP: $ZIP"
    echo "Lat/Lon: $LAT, $LON"
    echo "ISP: $ISP"

    # Simpan ke ip.txt
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] IP: $IP | $COUNTRY, $REGION, $CITY, ISP: $ISP" >> ip.txt
else
    echo "Gagal melacak IP: $IP"
fi
