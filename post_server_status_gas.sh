#!/bin/bash
post_url="$1"

cpu_temp=$(($(/usr/bin/cat /sys/class/thermal/thermal_zone0/temp)/1000))
ip_address=$(/usr/bin/curl "https://checkip.amazonaws.com/")
avail_fs=$(/usr/bin/df | /usr/bin/grep "/dev/root" | /usr/bin/awk '{ print $4/1024/1024 }')
free_mem=$(/usr/bin/free | /usr/bin/grep "Mem" | /usr/bin/awk '{ print $4/1024}')
temp_tlw=$(/usr/sbin/smartctl /dev/sda --all | /usr/bin/grep "Total_LBAs_Written" | /usr/bin/awk '{ print $10}')
temp_sector_size=512
tbw=$((${temp_tlw}*${temp_sector_size}/1024/1024/1024))
ssd_temp=$(/usr/sbin/smartctl /dev/sda --all | /usr/bin/grep -i "Airflow_Temperature_Cel" | /usr/bin/awk '{ print $10 }')

echo $cpu_temp
echo $ip_address
echo $avail_fs
echo $free_mem
echo $tbw
echo $ssd_temp

json=$(cat << EOS
{
	"cpu_temp": "${cpu_temp}",
	"ip_address": "${ip_address}",
	"avail_fs": "${avail_fs}",
	"free_mem": "${free_mem}",
	"tbw": "${tbw}",
	"ssd_temp": "${ssd_temp}"
}
EOS
)
echo $json
echo $json | jq
echo $post_url
/usr/bin/curl -L -d "${json}" ${post_url}
