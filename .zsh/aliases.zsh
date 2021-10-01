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
alias ssh="kitty +kitten ssh"

# Use old names for "neo" programs
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

# Git aliases
alias gcl='git clone'
alias ga='git add'
alias gp='git push'
alias gst='git status'
alias gcmsg='git commit -m'
alias gb='git branch'
alias gcb='git checkout -b'
alias gco='git checkout'

# Taskwarrior aliases
alias t='task'
alias ta='task add'
alias td='task done'
alias ttui='taskwarrior-tui'
