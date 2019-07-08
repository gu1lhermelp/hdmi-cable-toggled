#!/bin/bash

# Get hdmi connection status
# DISPLAY_ON='LVDS1'
# DISPLAY_OFF='HDMI1'
# AUDIO_OUTPUT='analog-stereo'

USER_NAME=$(who | awk -v vt=tty$(fgconsole) '$0 ~ vt {print $1}')
USER_ID=$(id -u "$USER_NAME")
PULSE_SERVER="unix:/run/user/"$USER_ID"/pulse/native"

export DISPLAY=:0
export XAUTHORITY=/home/$USER_NAME/.Xauthority

STATUS=$(</sys/class/drm/card0/card0-HDMI-A-1/status)
echo "HDMI $STATUS"
if [[ $STATUS == connected ]]; then
    if cat /sys/class/drm/card0/card0-HDMI-A-1/edid | parse-edid | grep SMBX2250 ; then
        xrandr --output LVDS1 --auto --primary --output HDMI1 --auto --right-of LVDS1
        sudo -u "$USER_NAME" pactl --server "$PULSE_SERVER" set-card-profile 0 output:analog-stereo+input:analog-stereo
    else
        xrandr --output LVDS1 --off --output HDMI1 --auto
        sudo -u "$USER_NAME" pactl --server "$PULSE_SERVER" set-card-profile 0 output:hdmi-stereo+input:analog-stereo
    fi
elif [[ $STATUS == disconnected ]]; then
    xrandr --output HDMI1 --off --output LVDS1 --auto
    sudo -u "$USER_NAME" pactl --server "$PULSE_SERVER" set-card-profile 0 output:analog-stereo+input:analog-stereo
fi
