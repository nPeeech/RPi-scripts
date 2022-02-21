#!/bin/bash
fname="$0"
post_url="$1"
ps_name="$2"

cpu_temp=$(($(/usr/bin/cat /sys/class/thermal/thermal_zone0/temp)/1000))
avail_fs=$(/usr/bin/df | /usr/bin/grep "/dev/root" | /usr/bin/awk '{ print $4/1024/1024 }')
free_mem=$(/usr/bin/free | /usr/bin/grep "Mem" | /usr/bin/awk '{ print $4/1024}')

# PNY. 120GB SATA III 6Gb/s Phantom-1 Seriesに特化した式を使用
# 他機種使用時はCrystalDiskInfoなどで値を確認後適当に式を立てる
temp_tlw=$(/usr/sbin/smartctl /dev/sda --all | /usr/bin/grep "Total_LBAs_Written" | /usr/bin/awk '{ print $10}')
temp_sector_size=512
# tbw[GB]
tbw=$temp_tlw
# ssd_temp[Celsius]
ssd_temp=$(/usr/sbin/smartctl /dev/sda --all | /usr/bin/grep -i "Temperature_Celsius" | /usr/bin/awk '{ print $10 }')

# 現在動いているプロセスの数
# temp_process_count=$(/usr/bin/ps aux | /usr/bin/cat | /usr/bin/grep ${ps_name} | /usr/bin/wc -l)
# process_count=$((${temp_process_count} - 3))
process_count=$(/usr/bin/ps aux | /usr/bin/grep ${ps_name} | /usr/bin/grep -v "\(${fname}\|grep\)" | /usr/bin/wc -l)

echo $cpu_temp
echo $avail_fs
echo $free_mem
echo $tbw
echo $ssd_temp
echo $process_count

json=$(cat << EOS
{
	"cpu_temp": "${cpu_temp}",
	"avail_fs": "${avail_fs}",
	"free_mem": "${free_mem}",
	"tbw": "${tbw}",
	"ssd_temp": "${ssd_temp}",
	"process_count": "${process_count}"
}
EOS
)
echo $json
echo $json | jq
echo $post_url
#echo $ps_name
#echo $(/usr/bin/ps aux | /usr/bin/grep ${ps_name} | /usr/bin/grep -v "\(${fname}\|grep\)" | /usr/bin/wc -l)
#echo $fname
#/usr/bin/ps aux | /usr/bin/grep ${ps_name} | /usr/bin/grep -v "\(${fname}\|grep\)" 

/usr/bin/curl -L -d "${json}" ${post_url}
