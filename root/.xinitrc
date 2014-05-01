export $(dbus-launch)

export $(gnome-keyring-daemon --start)

exec openbox-session
