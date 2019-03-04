#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.pyserial

import serial #import pyserial

ser = serial.Serial('/dev/ttyUSB0', 19200)

red_flashing = 'R*'.encode('ascii')

ser.write(red_flashing) #changes to static blue

ser.close()