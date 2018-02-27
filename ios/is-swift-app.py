#!/usr/local/bin/python3

# Author: Myo Soe, https://yehg.net 

# requires python 3, nm, otool
# decryped ipa file as 1st argument 
# demo: https://asciinema.org/a/UWKf3da1ZU2wcIl5XmSDOJBJu

import argparse
import subprocess

parser = argparse.ArgumentParser()

parser.add_argument("file", type=str, help="Specify path to decrypted iOS app file")
args = parser.parse_args()

path = args.file
path = path.strip()

nm_cmd = ['nm', path]

r_nm = subprocess.run(nm_cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')

if r_nm.find ("_OBJC_CLASS_$__") > -1:
    otool_cmd = ['otool', "-L" , path]
    r_otool = subprocess.run(otool_cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
    if r_otool.find("libswift")>-1:
        print("The app was written in Swift.")
        