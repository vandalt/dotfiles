# Useful onedrive functions and aliases

# Useful aliases to sync files
alias onestat='systemctl --user status onedrive'
alias onestart='systemctl --user start onedrive'
alias onestop='systemctl --user stop onedrive'
alias onenable='systemctl --user enable onedrive'
alias onedisable='systemctl --user disable onedrive'
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

