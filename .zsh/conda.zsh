# Enable conda (without activating)
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/miniconda3/etc/profile.d/conda.sh"
else
    export PATH="$HOME/miniconda3/bin:$PATH"
fi

# Inspired from https://github.com/dfm/dotfiles and https://github.com/leouieda/dotfiles and
cenv() {
read -r -d '' CENV_HELP <<-'EOF'
Usage: cenv [ACTION] [ARGS] [PACKAGES]
Actions:
  None            Creates or activates an environment
  new|create      Creates a new environment
  up|update       Update the environment
  upall|update-all
                  Update all packages inside envionment to most recent version.
                  This updates both conda and pip packages
  on|activate     Activates the environment
  off|deactivate  Equivalent to 'conda deactivate'
  add|install     Install a package
  rm|remove|uninstall
                  Uninstall a package
  dev|develop     Add development path to env (using conda.pth)
  clean           Remove the environment
  info            Show env info (conda info --envs output) and exit
Arguments:
  -h|--help       Show this message
  -n|--name       Name of the envionment
                  Default: active
  -d|--dir        Directory where env info is saved (yml, lock and req files)
                  Note: This is NOT the environment prefix
                  Default: ./env
  -f|--file       The conda environment file (in dir)
                  Default: environment.yml
  -l|--lock       The conda lock file (in dir)
                  Default: environment.lock
  --pip           Install or uninstall a package with pip
Packages: Packages to install
EOF

  condaVersion=`conda --version`
  echo "$condaVersion"

  # Find action
  case "$1" in
  new|create)
    action="create"
    shift
    ;;
  on|activate)
    action="activate"
    shift
    ;;
  off|deactivate)
    action="deactivate"
    shift
    ;;
  add|install)
    action="add"
    shift
    ;;
  rm|remove|uninstall)
    action="remove"
    shift
    ;;
  dev|develop)
    action="dev"
    shift
    ;;
  info)
    action="info"
    shift
    ;;
  up|update)
    action="update"
    shift
    ;;
  upall|update-all)
    action="upall"
    shift
    ;;
  clean)
    action="clean"
    shift
    ;;
  *)
    action="activate"
  esac

  if [[ "$action" = "deactivate" ]]; then
    conda deactivate
    return 0
  fi

  envDir="./env"
  help=n
  pip=n

  # Get active environment, if any
  current="$CONDA_DEFAULT_ENV"

  # now enjoy the options in order and nicely split until we see --
  while true; do
    case "$1" in
      -h|--help)
        help=y
        shift
        ;;
      --pip)
        pip=y
        shift
        ;;
      -n|--name)
        envName="$2"
        shift 2
        ;;
      -d|--dir)
        envDir="$2"
        shift 2
        ;;
      -f|--file)
        envFile="$2"
        shift 2
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
    echo $CENV_HELP
    return 0
  fi

  if [[ "$action" = "info" ]]; then
    conda info --envs
    return 0
  fi

  # Take dir from env File if available
  if [[ ! -z "$envFile" ]]; then
    envDir=`dirname $envFile`
  fi

  # Assign env files
  if [[ -z "$envFile" ]]; then
    envFile="$envDir/environment.yml"
  fi
  if [[ -z "$lockFile" ]]; then
    lockFile="$envDir/environment.lock"
  fi
  pipFile="$envDir/requirements.txt"

  # Check we have a file
  fileExists=n
  if [[ -f "$envFile" ]]; then
    fileExists=y
  fi

  # Make sure we have an env name
  if [[ -z "$envName" ]]; then
    if [[ ! -z "$current" ]]; then
      envName="$current"
    elif [[ "$fileExists" = "y" ]]; then
      envName=`sed -n -e 's/^name: //p' "$envFile"`
    fi
  fi
  if [[ -z "$envName" ]]; then
    # If still no env name, we have a problem
    echo "No env name found. Either run this from an active environment, specify --name, or make sure that the env file contains a name"
    return 1
  fi

  # Check if target env is active
  active=n
  if [[ "$current" = "$envName" ]]; then
    active=y
  fi

  # Check the env exists
  envExists=n
  if conda info --envs | grep -q "^$envName"; then
    envExists=y
  fi

  if [[ $envExists = "n" ]]; then
    if [[ "$action" = "activate" ]] || [[ "$action" = "update" ]]; then
      action="create"
    elif [[ "$action" != "create" ]]; then
      echo "Environment $envName not found";
      return 1
    fi
  fi

  # If clean, just remove
  if [[ "$action" = "clean" ]]; then
    read "flag?Remove this environment ($envName)? [y/N]: "
    if [[ "$flag" = "y" ]] || [[ "$flag" = "Y" ]]; then
      echo -n "Removing: $lockFile"
      # make sure no env active
      conda deactivate
      rm -rf "$lockFile $pipFile"
      conda remove --name $envName --all
      return 0
    elif [[ "$flag" = "n" ]] || [[ "$flag" = "N" ]]; then
      echo "Aborting."
      return 0
    else
      "Answer must be y or n, exiting"
      return 2
    fi
  fi

  if [[ "$action" = "activate" ]]; then
    if [[ $envExists = "n" ]]; then
      echo "Environment $envName not found"
      return 3
    fi
    echo "Activating environment $envName"
    conda activate $envName
    return 0
  fi

  if [[ "$action" = "dev" ]]; then
    if [[ "$active" = "n" ]]; then
      conda activate $envName
    fi
    conda develop $@
    if [[ "$active" = "n" ]]; then
      conda deactivate
    fi
  fi

  # Make sure dir exists
  if [[ ! -d "$envDir" ]]; then
    mkdir -p $envDir
  fi

  # All these other actions modify the env, so we use an if statement because we need to save the config at the very end
  if [[ "$action" = "create" ]]; then
    if [[ "$envExists" = "y" ]]; then
      echo "Environment $envName already exists"
      return 4
    fi
    if [[ $fileExists = "y" ]]; then
      echo "Creating a new environment from: $envFile with name $envName"
      conda env create --file $envFile --name $envName
    else
      echo "Creating a new environment with arguments: $@"
      conda create --name $envName python pip $@
    fi
    conda activate $envName

  elif [[ "$action" = "update" ]]; then
    echo "Updating environment: $envFile -> $envName"
    conda env update --name $envName -f $envFile --prune

  elif [[ "$action" = "add" ]]; then
    if [[ "$pip" = "y" ]]; then
      if [[ "$active" = "n" ]]; then
        conda activate $envName
      fi
      echo "Installing (using pip): $@"
      python -m pip install $@
      for dep in $@
      do
        echo $dep >> $pipFile
      done
      if [[ "$active" = "n" ]]; then
        conda deactivate $envName
      fi
    else
      echo "Installing: $@"
      conda install --name $envName $@
    fi

  elif [[ "$action" = "remove" ]]; then
    if [[ "$pip" = "y" ]]; then
      if [[ "$active" = "n" ]]; then
        conda activate $envName
      fi
      echo "Installing (using pip): $@"
      python -m pip uninstall $@
      for dep in $@
      do
        sed '/^$@/ d' $pipFile > $pipFile
      done
      if [[ "$active" = "n" ]]; then
        conda deactivate $envName
      fi
    else
      echo "Installing: $@"
      conda remove --name $envName $@
    fi
  fi

  # Update config
  echo "name: $envName" > $envFile
  conda env export --name "$envName" --from-history | sed '1d;/^$/d' | sed '$d' >> $envFile
  if [[ -f "$pipFile" ]]; then
    echo "  - pip:" >> $envFile
    echo "    - -r requirements.txt" >> $envFile
  fi
  conda env export --name $envName > $lockFile

  # Unset some things
  envName=""
  envDir=""
  envFile=""
  current=""
}

cdenv() {
  # Function to cd in env and activate (take name from file)
  # Must have env file in ./env/environment.yml
  cd $1;
  con
}

coff() {
  # Deativate current env
  conda deactivate
}

con() {
  # Function to activate env of project (take name from file)
  envName=`sed -n -e 's/^name: //p' ./env/environment.yml`
  conda activate $envName
}

# Useful aliases related to conda
alias coff='conda deactivate'
alias cinenv='conda info --envs'
