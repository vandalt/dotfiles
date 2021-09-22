# export MPLBACKEND=GTK3Agg
# export MPLBACKEND=Qt5Agg
# If running from tty1 start sway
export EDITOR="nvim"
if [ "$(tty)" = "/dev/tty1" ]; then
    export XDG_CURRENT_DESKTOP=sway
    export _JAVA_AWT_WM_NONREPARENTING=1
    export MOZ_ENABLE_WAYLAND=1
    export MOZ_DBUS_REMOTE=1
    exec sway
fi
