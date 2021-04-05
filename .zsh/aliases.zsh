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

# JWST APT
alias aptool='~/Programs/APT_2020.4.1/APT'

# Taskwarrior aliases
alias taskl='task +OVERDUE'
alias taskn='task +next'
alias taskg='git -C ~/.task pull'
alias taskc='git -C ~/.task commit -a -m "add latest tasks"'
alias taskp='git -C ~/.task push'

# Use neovim
alias v='nvim'
alias vim='nvim'
alias cnvim='nvim ~/.config/nvim/init.vim'

# Git dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cst='config status'
alias ca='config add'
alias ccmsg='config commit -m'
alias cb='config branch'
alias ccb='config checkout -b'
alias cco='config checkout'
alias cdf='config diff'
alias cpsh='config push'

# Git private dotfiles
alias pconfig='/usr/bin/git --git-dir=$HOME/.private_dotfiles/ --work-tree=$HOME'
alias pcst='pconfig status'
alias pca='pconfig add'
alias pccmsg='pconfig commit -m'
alias pcb='pconfig branch'
alias pccb='pconfig checkout -b'
alias pcco='pconfig checkout'
alias pcdf='pconfig diff'
alias pcpsh='pconfig push'

# Google calendar CLI
alias gadd='gcalcli add'
alias gcalm='gcalcli calm'
alias gcalw='gcalcli calw'
alias gagenda='gcalcli agenda'

# Kitty terminal
alias icat="kitty +kitten icat"

# Navigation
alias ...="cd ../.."
alias cdwin="/mnt/c/Users/thoma"

# Java scaling
alias topcat='topcat -Dsun.java2d.uiScale=2'

# Python
alias jlab='jupyter lab'
alias jnote='jupyter notebook'
alias p='ipython'
alias python='python3'

# Power
alias sdn='shutdown now'
alias rbt='reboot'

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
