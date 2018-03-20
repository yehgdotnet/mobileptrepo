#!/usr/bin/env bash

# usage ./buildsignapk.sh [App_DIR] [App_Name]

apktool b "$1"
keytool -genkey -v -keystore yehg.keystore -alias yehg.key -keyalg RSA -validatity 10000
jarsigner -keystore yehg.keystore "$2" yehg.key