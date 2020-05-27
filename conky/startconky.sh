#!/bin/bash

sleep 3 #time (in s) for the DE to start; use ~20 for Gnome or KDE, less for Xfce/LXDE etc
conky -c ~/.Conky/rings &
sleep 8
conky -c ~/.Conky/mem &
sleep 1
conky -c ~/.Conky/cpu&
sleep 1
conky -c ~/.Conky/wifi