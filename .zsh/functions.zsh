# mkdir and cd at once
function mkcd() {
    mkdir -p "$1" && cd "$1";
}

# View csv with less and column tools
function csview {
    column -s, -t "$@" | less -N -S
}

# Customize jupyter lab
function extjlab {
  # jupyter labextension install @karosc/jupyterlab_dracula
  jupyter labextension install @vandalt/jupyterlab_dracula  # with scroll padding
  jupyter labextension install @axlair/jupyterlab_vim
}
