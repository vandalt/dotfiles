#!/bin/zsh
## source: https://github.com/Manjaro-Sway/desktop-settings/blob/sway/community/sway/etc/skel/.profile
## make default editor Neovim
export EDITOR=nvim

#
#eval $(gnome-keyring-daemon --start)
#export SSH_AUTH_SOCK
#
## Most pure GTK3 apps use wayland by default, but some,
## like Firefox, need the backend to be explicitely selected.
export MOZ_ENABLE_WAYLAND=1
# export MOZ_DBUS_REMOTE=1
# export GTK_CSD=0

# qt wayland
export QT_QPA_PLATFORM="wayland"
# export QT_QPA_PLATFORMTHEME=qt5ct
# export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

#Java XWayland blank screens fix
export _JAVA_AWT_WM_NONREPARENTING=1

# set default shell and terminal
export SHELL=/usr/bin/zsh
#export SHELL=/usr/bin/bash
# export TERMINAL_COMMAND=/usr/bin/alacritty

# User specific environment
# Added here to make accessible to gnome night theme switcher
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# For juypter lab
export WEBBPSF_PATH=$HOME/Documents/data/package-data/webbpsf-data
export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab
export XLA_FLAGS="--xla_force_host_platform_device_count=8 --xla_cpu_multi_thread_eigen=false intra_op_parallelism_threads=1"

# [ "$(tty)" = "/dev/tty1" ] && exec sway
