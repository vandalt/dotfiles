if [[ ! -o login ]]
then

    # Python tools
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    export PATH="$HOME/.poetry/bin:$PATH"
    #
    # Home bin(s)
    if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
    then
        PATH="$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:$PATH"
    fi
    # This is for archlinux installation with openblas
    export THEANO_FLAGS=blas__ldflags="-L/usr/lib/ -lopenblas"

    # Doom emacs command
    export PATH="$HOME/.emacs.d/bin:$PATH"

    ### Linear algebra
    # MKL
    export MKL_DYNAMIC=FALSE
    export MKL_CBWR=COMPATIBLE
    export MKL_NUM_THREADS=1
    # OPENBLAS
    export OPENBLAS_NUM_THREADS=1
    # Note: OMP changes nproc to 1
    # export OMP_NUM_THREADS=1
    # Others
    export VECLIB_MAXIMUM_THREADS=1
    export NUMEXPR_NUM_THREADS=1

    # Jupyter lab extension in userland
    export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab

    # nnn vars
    export NNN_BMS="d:$HOME/Documents;h:/home/vandal;D:$HOME/Downloads/;k:$HOME/Desktop/;p:$HOME/projects/"
    # NOTE: python jwst package has jump "false positive" with pyenv shims, can delete bin file, should open issue
    export NNN_PLUG='s:syncpwd;z:autojump;b:bulknew;d:diffs;f:fzopen;g:syncplugs'

    # Misc
    export WEBBPSF_PATH=$HOME/Documents/jwst_data/webbpsf-data
fi
export PATH
