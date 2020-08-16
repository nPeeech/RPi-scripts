import time
import RPi.GPIO as GPIO
import subprocess

GPIO.setmode(GPIO.BCM)

GPIO.setup(18,GPIO.IN,pull_up_down=GPIO.PUD_UP)

try:
    while True:
        GPIO.wait_for_edge(18,GPIO.FALLING)
        sw_counter = 0
        
        while True:
            sw_status = GPIO.input(18)

            if sw_status == 0:
                sw_counter = sw_counter + 1
                
                if sw_counter >= 200:
                    subprocess.call("sudo shutdown -h now",shell=True)
                    print("OK")
                    break
            else:
                break

            time.sleep(0.01)
        print(sw_counter)
       
except KeyboardInterrupt:
    pass
finally:
    GPIO.cleanup()
