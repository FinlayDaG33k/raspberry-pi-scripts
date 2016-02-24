## Script By FinlayDaG33k under the MIT License ##
import os 
import RPi.GPIO as gpio
import time
import socket

## set variables for the machine to ping and pin for the LED
hostname = "kandicraft.finlaydag33k.nl"
port = 25565
led_pin = 37

## prepare
led_status = gpio.LOW
gpio.setmode(gpio.BOARD)
gpio.setup(led_pin, gpio.OUT, gpio.PUD_OFF, led_status)

## the main ping function
def check_ping(host, port):
    captive_dns_addr = ""
    host_addr = ""

    try:
        captive_dns_addr = socket.gethostbyname("BlahThisDomaynDontExist22.com")
    except:
        pass

    try:
        host_addr = socket.gethostbyname(host)

        if (captive_dns_addr == host_addr):
            return False

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(1)
        s.connect((host, port))
        s.close()
    except:
        return False

    return True

	
	
## Run the script itself infinitely
while True:
    pingstatus = check_ping(hostname,port)
    if pingstatus == False:
        print('Setting pin to HIGH')
        led_status = gpio.HIGH
    else:
        print('Setting pin to LOW')
        led_status = gpio.LOW
	gpio.output(led_pin,led_status) # set the LED to it's proper position
	time.sleep(10) # wait for 10 seconds to rerun the loop
