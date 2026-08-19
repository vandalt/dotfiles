#!/usr/bin/bash

case "$1" in
  dark) mode="Dark" ;;
  light) mode="Light" ;;
esac
notify-send "$mode"
