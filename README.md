# Pythonスクリプト
キャラクタLCD：[AQM0802A](http://akizukidenshi.com/catalog/g/gM-11753/)  
write_rx_bytes_lcd.pyは[I2C接続AQMシリーズのキャラクタ表示LCDをラズパイで使う　(1) AQM0802](https://www.denshi.club/pc/raspi/i2caqmlcdarduinode1-aqm0802.html)を参考にさせていただきました．  
```
@reboot python3 ~/RPi-scripts/write_lcd.py
@reboot python3 ~/RPi-scripts/shutdown.py
```

# config.txt
- Bluetooth，WiFi無効化  
- 温度制限60℃ 

# post_server_status_gas.sh
- `bash post_server_status_gas.sh https://example.com`  
