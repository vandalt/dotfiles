#!/usr/bin/zsh
# Python
alias p='ipython'
# enable shared libraries (requied for some packages like theano)
alias spyenv='env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv'
alias pup='python -m pip install -U pip'
# Default venv config
# alias nvenv='python -m venv venv'

# ipython updates somtimes break things, install only < IPYTHON_MAX_VERSION
# IPYTHON_MAX_VERSION=8

# alias pact='source venv/bin/activate'

pact() {
  dirPrefix=$1
  if [[ -z "$dirPrefix" ]]; then
    dirPrefix="."
  fi
  source "$dirPrefix/venv/bin/activate"
}

pydefaults() {
  # Some default packages. In a function to access outside nvenv
  ipystr="ipython"
  if [[ "$#" -ge 1 ]]; then
    if [[ "$1" -le 3.8 ]]; then
      ipystr="ipython<=8.12"
    fi
  fi
  python -m pip install -U "$ipystr" ipdb ipykernel pyqt6 flake8 flake8-bugbear isort black jupytext copier
}

addipy() {
  echo $envName
  envName=$1

  if [[ -z "$envName" ]]; then
    echo "Please provide an environment name to register with jupyter"
    return 1
  elif jupyter kernelspec list | tail -n +2 | awk '{print $1}' | grep -xq $envName; then
    # If kernel exists, require a different name
    echo "Kernel $envName is already registered with jupyter."
    echo "You can register it with: python -m ipykernel install --user --name=\$myEnvName"
    echo "To remove the existing $envName kernel, use: jupyter kernelspec remove $envName"
    return 2
  else
    python -m ipykernel install --user --name=$envName
  fi

}

nvenv() {
read -r -d '' NVENV_HELP <<-'EOF'
Create new python venv

Usage nvenv [ARGS]

Arguments:
  -h|--help       Show this message
  -n|--name       Name of the virtual envionment (used to register with ipykernel).
                  Defaults to parent directory name
  -v|--version    Python version to use to create the environment
  -d|--dir        Directory where venv is created. Defaults to venv
  -e|--exit       Deactivate the  environment after creating it
EOF

  # Check args
  while true; do
    case "$1" in
      -h|--help)
        help=y
        shift
        ;;
      -n|--name)
        envName="$2"
        shift 2
        ;;
      -v|--version)
        pyVer="$2"
        shift 2
        ;;
      -d|--dir)
        envDir="$2"
        shift 2
        ;;
      -e|--exit)
        deact=y
        shift
        ;;
      --)
        shift
        break
        ;;
      *)
        break
        ;;
    esac
  done

  if [[ "$help" = "y" ]]; then
    echo $NVENV_HELP
    return 0
  fi

  if [[ -z "$envDir" ]]; then
    envDir="venv"
  fi

  if [[ -z "$pyVer" ]]; then
    pycmd="python"
  else
    pycmd="python$pyVer"
  fi

  if [[ -d "$envDir" ]]; then
    echo "Directory $envDir already exists. Exiting."
    return 1
  fi

  parentDir=$(dirname $envDir)

  # Make sure parent dir exists
  if [[ ! -d "$parentDir" ]]; then
    mkdir -p $parentDir
  fi

  if [[ -z "$envName" ]]; then
    # Make sure full path and not just "."
    realParDir=$(realpath $parentDir)
    # Get last dir only
    envName=${realParDir##*/}
  fi

  $pycmd -m venv $envDir

  source $envDir/bin/activate

  echo "Virtual environment using: $(which python)"

  # Update pip first
  $pycmd -m pip install -U pip wheel

  if [[ -z "$pyVer" ]]; then
    pydefaults
  else
    pydefaults "$pyVer"
  fi

  # Make env available with jupyterlab
  echo ""
  addipy $envName
  # if jupyter kernelspec list | tail -n +2 | awk '{print $1}' | grep -xq $envName; then
  #   # If kernel exists, require a different name
  #   echo "Kernel $envName is already registered with jupyter."
  #   echo "You can register it with: python -m ipykernel install --user --name=\$myEnvName"
  #   echo "To remove the existing $envName kernel, use: jupyter kernelspec remove $envName"
  # else
  #   python -m ipykernel install --user --name=$envName
  # fi

  # By default, stay in venv after creating it
  if [[ "$deact" = "y" ]]; then
    deactivate
  else
    # IPython sometimes shows warning if don't exit and re-enter after installing it
    deactivate
    source $envDir/bin/activate
  fi

  # Unset some things
  envName=""
  envDir=""
}
