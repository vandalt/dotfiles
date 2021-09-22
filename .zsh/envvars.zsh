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
fi
export PATH
