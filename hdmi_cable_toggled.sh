#!/bin/bash

# Get hdmi connection status
DISPLAY_ON='LVDS1'
DISPLAY_OFF='HDMI1'
AUDIO_OUTPUT='analog-stereo'

USER_NAME=$(who | awk -v vt=tty$(fgconsole) '$0 ~ vt {print $1}')
USER_ID=$(id -u "$USER_NAME")
PULSE_SERVER="unix:/run/user/"$USER_ID"/pulse/native"

export DISPLAY=:0
export XAUTHORITY=/home/$USER_NAME/.Xauthority

STATUS=$(</sys/class/drm/card0/card0-HDMI-A-1/status)
echo "HDMI $STATUS"
if [[ $STATUS == connected ]]; then
    DISPLAY_ON='HDMI1'
    DISPLAY_OFF='LVDS1'
    AUDIO_OUTPUT='hdmi-stereo'
elif [[ $STATUS == disconnected ]]; then
    DISPLAY_ON='LVDS1'
    DISPLAY_OFF='HDMI1'
    AUDIO_OUTPUT='analog-stereo'
fi

echo "Selecting output $DISPLAY_ON. $DISPLAY_OFF will be turned off."
xrandr --output $DISPLAY_OFF --off --output $DISPLAY_ON --auto
sudo -u "$USER_NAME" pactl --server "$PULSE_SERVER" set-card-profile 0 output:$AUDIO_OUTPUT+input:analog-stereo
