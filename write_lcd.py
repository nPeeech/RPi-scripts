import smbus
import time
import subprocess
 
i2c = smbus.SMBus(1) # 1 is bus number
i2c_addr=0x3e #lcd
resister_aqm0802=0x00
data=0x40
clear=0x01
home=0x02
display_On=0x0f
LCD_2ndline=0x40+0x80
 
def command( code ):
        i2c.write_byte_data(i2c_addr, resister_aqm0802, code)
        time.sleep(0.1)
 
def writeLCD( message ):
        mojilist=[]
        for moji in message:
                mojilist.append(ord(moji)) 
        i2c.write_i2c_block_data(i2c_addr, data, mojilist)
        time.sleep(0.1)
 
def init_lcd ():
        command(0x38)
        command(0x39)
        command(0x14)
        command(0x73)
        command(0x56)
        command(0x6c)
        command(0x38)
        command(clear)
        command(display_On)
 
#main
init_lcd()
command(clear)
writeLCD("Hello!!")
command(LCD_2ndline)
writeLCD("World!!")

time.sleep(5)
command(clear)
writeLCD("RX[MB]=")

while True:
    command(LCD_2ndline)
    res = subprocess.check_output("cat /proc/net/dev | grep eth1 | awk '{print $2/1024/1024}'",shell=True)
    res = res.decode()
    writeLCD(res)


    time.sleep(1)
    #command(clear)
