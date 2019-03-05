#!/usr/bin/env nix-shell
#! NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs nix_shell -i python3 -p "python3.withPackages(ps: [ps.pyserial])"
import serial #import pyserial

ser = serial.Serial('/dev/ttyUSB0', 19200)

red_flashing = 'R*'.encode('ascii')

ser.write(red_flashing) #changes to static blue

ser.close()