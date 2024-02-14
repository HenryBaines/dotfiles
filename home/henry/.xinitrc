#!/bin/sh


##################################################################
### CODE TAKEN FROM DEFAULT .xinitrc IN /etc/X11/xinit/xinitrc ###
##################################################################


### NOT ESSENTIAL BUT COPIED ANYWAYS

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi


### ESSENTIAL AS DESCRIBED IN THE XINIT ARCH WIKI
##  start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi


################################
### MY CODE NO LONGER IN USE ###
################################


#bluetoothctl connect 78:05:09:14:13:A0 &

#Prevent file manager from starting with 25s delay:
#dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
#NO LONGER NEEDED, problem solved by removing xdg-desktop-portal-gnome package, which is broken

#Map wacom tablet to native monitor
#xsetwacom set 'Wacom One by Wacom S Pen stylus' MapToOutput eDP1 &
#xsetwacom set 'Wacom One by Wacom S Pen eraser' MapToOutput eDP1 &

#Start insync, Google Drive client - UNINSTALLED
#insync start &


#############################################
### MY CODE THAT I AM USING AT THE MOMENT ###
#############################################


### SETS WALLPAPER AND START VARIETY

nitrogen --restore &
variety &


### START NETWORK MANAGER APPLET

nm-applet --indicator &


### SET KEYBOARD AND GRAPHICS

setxkbmap -layout gb &
picom &
unclutter --jitter 10 --ignore-scrolling --start-hidden --fork
dunst &


### START POLKIT AUTHENTICATION AGENT

/usr/bin/lxpolkit &


### DETECT DISPLAYS, UPDATE RESOLUTION AND TOUCHSCREEN
## First update resolution, then map touchscreen surface to native monitor

autorandr -c
xinput --map-to-output 'ELAN901C:00 04F3:2C4E' eDP1 &


### STARTS KEYRING AND SECRETS
## Can be placed before or after qtile start, needed for GIT integration, packages: gnome-keyring, libsecret

dbus-update-activation-environment --all
gnome-keyring-daemon --start --components=secrets


### START QTILE WINDOW MANAGER

qtile start

