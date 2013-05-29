#!/bin/bash
export BROWSER=firefox
export DE=awesome

# Dbus fix
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

dropboxd &
mpd &
mpdscribble &
urxvtd -q -o -f &
setxkbmap -layout "us, ara" -option "grp:alt_shift_toggle"
lightsOn.sh 120 &
xautolock -locker slimlock -time 15 &
wicd-client -o &
system-config-printer-applet &
#(sleep 5 && devmon) &
#(sleep 10 && conky -c ~/.conky/.conkyrc) &

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

DEFAULT_SESSION=awesome

case $1 in
openbox)
	exec openbox-session
	;;
xfce4)
	exec startxfce4
	;;
dwm)
	dwm
	;;
mate)
	mate-session
	;;
awesome)
	exec /usr/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
	;;
kde)
	exec startkde
	;;
lkde)
	exec startlkde
	;;
blackbox)
	exec blackbox
	;;
*)
	exec $DEFAULT_SESSION
	;;
esac
 

