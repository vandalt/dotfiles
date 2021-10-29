# enable colors in ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Use kitty terminfo to ssh
if [ $TERM = xterm-kitty ]; then
    alias ssh="kitty +kitten ssh"
fi

alias auracle='auracle -C ~/aur'

# Open files with $EDITOR
alias nnn='nnn -e'
alias syncnplug='cp /usr/share/nnn/plugins/{*,.*} ~/.config/nnn/plugins'

# Use old names for "neo" programs
alias v='nvim'
alias vim='nvim'
alias mutt="neomutt"

# Shortcuts to open configs
alias cnvim='nvim ~/.config/nvim/init.lua'
alias csway='nvim ~/.config/sway/config'
alias cterm='nvim ~/.config/kitty/kitty.conf'
alias zshrc='nvim ~/.zshrc'
alias zshdir='nvim ~/.zsh'


alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias pconfig='/usr/bin/git --git-dir=$HOME/.private_dotfiles/ --work-tree=$HOME'
alias ..="cd .."
alias ...="cd ../.."

alias jlab='jupyter lab'
alias p='ipython'
# enable shared libraries (requied for some packages like theano)
alias spyenv='env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv'
alias pup='python -m pip install -U pip'
# alias mplback='python -m pip install -U pycairo PyGObject'
alias mplback='python -m pip install -U pyqt5'

alias code='code --enable-features=UseOzonePlatform --ozone-platform=wayland'

# Utils
alias l='ls'
alias sl='ls'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lA'
alias llt='ls -lt'
alias lltr='ls -ltr'
alias rmr='rm -r'
alias rmrf='rm -rf'
alias dh='du -sch *'
alias dha='du -d 1 -h .'
alias untar='tar -xvf'
alias guntar='tar -xzvf'
alias buntar='tar -xjvf'
alias open='xdg-open'
alias scr='screen -r'
alias scs='screen -S'
alias scls='screen -ls'

# Sway things
# NOTE: No "toggle" for mako modes yet (https://github.com/emersion/mako/pull/382)
alias dnd='makoctl set-mode do-not-disturb'
alias dndoff='makoctl set-mode default'

# Power
alias sdn='shutdown now'

# Taskwarrior aliases
alias t='task'
alias tstop='task +ACTIVE stop'
alias ta='task add'
alias tai='task add +inbox'
alias td='task done'
alias ttui='taskwarrior-tui'
alias to='taskopen'
alias te='task edit'
