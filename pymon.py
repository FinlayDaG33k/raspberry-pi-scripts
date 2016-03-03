import os 
import RPi.GPIO as gpio
import time
import socket

## set variables for the machine to ping and pin for the LED
hostname = ['kandicraft.finlaydag33k.nl:25565','www.finlaydag33k.nl']
led_pin = 37
activity_led = 13

## prepare
led_status = gpio.LOW
activity_status = gpio.LOW
gpio.setmode(gpio.BOARD)
gpio.setup(led_pin, gpio.OUT, gpio.PUD_OFF, led_status)
gpio.setup(activity_led, gpio.OUT, gpio.PUD_OFF, activity_status)

## PING FUNCTION GALORE!!
def check_ping(host,port):
    gpio.output(activity_led,gpio.HIGH)
    captive_dns_addr = ""
    host_addr = ""
    try:
        host_addr = socket.gethostbyname(host)

        if (captive_dns_addr == host_addr):
            return False

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(1)
        s.connect((host,port))
        s.close()
    except Exception as exc:
        return False
    return True
    gpio.output(activity_led,gpio.LOW)
	
	
## Run the script itself infinitely
try:
    while True:
        host_up = ""
        for host in hostname:
            if ":" in host:
                temphost = ""
                temphost, tempport = host.split(":")
            else: 
                temphost = host
                tempport = 80
            pingstatus = check_ping(temphost, int(tempport))
            if pingstatus == False:
                print('[' + time.strftime("%d-%m-%Y %H:%M:%S") + '] ' + str(temphost) + ' on port ' + str(tempport) + ' seems to be unreachable!')
                host_up = "False"

        if host_up == "False":
            led_status = gpio.HIGH
        else:
            led_status = gpio.LOW
        gpio.output(led_pin,led_status)
        time.sleep(1)
except KeyboardInterrupt:
    gpio.cleanup()
