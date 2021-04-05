# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable conda completion
fpath+=$HOME/.zsh/conda-zsh-completion

# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

# Source Powerlevel10k
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# Source syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Source autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Source all config files
for config_file ($HOME/.zsh/*.*sh) source $config_file

# Must be after vi-mode set in config files
# source /usr/share/fzf/shell/key-bindings.zsh
# source /usr/share/fzf/completion.zsh

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="/home/vandal/Programs/texlab/target/release:$HOME/.local/bin:$HOME/bin:$PATH"
fi

if ! [[ "$PATH" =~ "/usr/bin/core_perl:" ]]
then
    PATH="/usr/bin/core_perl:$PATH"
fi

# Env vars
export PATH
export DISPLAY="`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0"
export EDITOR="vi"
export SCREENDIR=$HOME/.screen
export LD_LIBRARY_PATH=/home/vandal/astro-dev/MultiNest/lib/:$LD_LIBRARY_PATH
export GDK_DPI_SCALE=2.0
export GDK_SCALE=0.5

# QT apps
# export QT_QPA_PLATFORM=wayland
# export QT_QPA_PLATFORMTHEME=gtk2
# export QT_QPA_PLATFORMTHEME=wayland-egl
# export QT_WAYLAND_FORCE_DPI=96

# Firefox on wayland
# MOZ_ENABLE_WAYLAND=1
# export MOZ_ENABLE_WAYLAND

export EDITOR="nvim"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
