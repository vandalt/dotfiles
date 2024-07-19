# Useful onedrive functions and aliases

# Useful aliases to sync files
alias onestat='systemctl --user status onedrive'
alias onestart='systemctl --user start onedrive'
alias onestop='systemctl --user stop onedrive'
alias onenable='systemctl --user enable onedrive'
alias onedisable='systemctl --user disable onedrive'
alias oneup='onedrive --synchronize --upload-only --no-remote-delete'
alias onesync='onedrive --synchronize'
alias oneresync='onedrive --synchronize --resync'
alias onemonit='onedrive --monitor'

# Sync forever. Useful when onesync keeps breaking and have to update a lot of files
infsync() {
  while :
  do
      onedrive --synchronize
      echo "STOPPED HERE"
      echo ""
      echo "RESTART"
  done
}

infup() {
  echo "Running once"
  while
  do
    wrapup
    echo "Restarting..."
  done
}

wrapup() {
  while read -r line
  do
    if [[ "$line" == *"Error Message: There was a timeout"* ]]; then
      echo "Timeout message. Re-running command..."
      return 1
    else
      echo "$line"
    fi
  done < <(oneup 2>&1)
}
