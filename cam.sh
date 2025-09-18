#!/bin/bash
# Lacak IP Privat / Publik
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

read -p "Masukkan IP (privat atau publik): " IP

if [[ -z "$IP" ]]; then
    echo "[!] IP tidak boleh kosong"
    exit 1
fi

# Cek apakah IP privat atau publik
IFS='.' read -r o1 o2 o3 o4 <<< "$IP"
IS_PRIVATE=false
if [[ "$o1" -eq 10 ]] || \
   [[ "$o1" -eq 172 && "$o2" -ge 16 && "$o2" -le 31 ]] || \
   [[ "$o1" -eq 192 && "$o2" -eq 168 ]] || \
   [[ "$IP" == "127.0.0.1" ]]; then
    IS_PRIVATE=true
fi

if $IS_PRIVATE ; then
    echo -e "\n[*] IP Privat terdeteksi, menampilkan info jaringan lokal..."
    INTERFACE=$(ip -o addr show | grep "$IP" | awk '{print $2}')
    if [[ -z "$INTERFACE" ]]; then
        INTERFACE="Tidak ditemukan"
        NETMASK="-"
        MAC="-"
        GATEWAY="-"
    else
        NETMASK=$(ip -o addr show $INTERFACE | grep "$IP" | awk '{print $4}')
        MAC=$(cat /sys/class/net/$INTERFACE/address)
        GATEWAY=$(ip route | grep default | awk '{print $3}')
    fi
    HOSTNAME=$(hostname)
    OS=$(uname -a)

    echo "================= DETAIL IP PRIVAT ================="
    echo "IP Address     : $IP"
    echo "Interface      : $INTERFACE"
    echo "Netmask / CIDR : $NETMASK"
    echo "MAC Address    : $MAC"
    echo "Gateway        : $GATEWAY"
    echo "Hostname       : $HOSTNAME"
    echo "OS             : $OS"
    echo "Lokasi         : Tidak tersedia (IP privat)"
    echo "==================================================="

    # Simpan ke log
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] IP: $IP | Interface: $INTERFACE | Netmask: $NETMASK | MAC: $MAC | Gateway: $GATEWAY | Host: $HOSTNAME | OS: $OS | Lokasi: Privat" >> ip_lacak.txt

else
    echo -e "\n[*] IP Publik terdeteksi, menampilkan info lokasi..."
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
        ORG=$(echo "$DATA" | grep -o '"org":"[^"]*' | cut -d'"' -f4)
        TIMEZONE=$(echo "$DATA" | grep -o '"timezone":"[^"]*' | cut -d'"' -f4)
        ASN=$(echo "$DATA" | grep -o '"as":"[^"]*' | cut -d'"' -f4)

        echo "================= DETAIL IP PUBLIK ================="
        echo "IP Address     : $IP"
        echo "Negara         : $COUNTRY"
        echo "Region         : $REGION"
        echo "Kota           : $CITY"
        echo "ZIP            : $ZIP"
        echo "Latitude/Long  : $LAT, $LON"
        echo "ISP            : $ISP"
        echo "Organisasi     : $ORG"
        echo "Timezone       : $TIMEZONE"
        echo "ASN            : $ASN"
        echo "==================================================="

        # Simpan ke log
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] IP: $IP | Country: $COUNTRY | Region: $REGION | City: $CITY | ZIP: $ZIP | Lat/Lon: $LAT,$LON | ISP: $ISP | Org: $ORG | Timezone: $TIMEZONE | ASN: $ASN" >> ip_lacak.txt
    else
        echo "Gagal melacak IP publik: $IP"
    fi
fi

echo -e "\n[*] Semua hasil disimpan di ip_lacak.txt"
