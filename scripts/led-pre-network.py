#!/usr/bin/env nix-shell
#! nix-shell -E 'with import <nixpkgs> {}; stdenv.mkDerivation { name = "led-red"; buildInputs = [ python3.pkgs.pyserial ]; }'

import serial #import pyserial

ser = serial.Serial('/dev/ttyUSB0', 19200)

red_flashing = 'R*'.encode('ascii')

ser.write(red_flashing) #changes to static blue

ser.close()