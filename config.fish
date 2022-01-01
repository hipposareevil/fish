# Path
set BACKUP_ROOT_DIRECTORY $HOME/hippo_bak
set ICLOUD_DIR $HOME/icloud
set DOT_FILES $ICLOUD_DIR/tech/dotfiles

fish_add_path ~/bin/
fish_add_path $DOT_FILES/bin/
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/wpff/auto_backup


# abbreviations
abbr -a -g ag "ag --hidden"
abbr -a -g commit "git commit --all -m "
abbr -a -g wpff "ssh web@willprogramforfood.com -p 66"
abbr -a -g nextcloud "ssh hippo@hipposareevil.com"
abbr -a -g epoch "perl -le 'print scalar localtime $argv[1]'"
abbr -a -g rebase "git rebase -i HEAD~"
abbr -a -g rebase.date "git rebase --ignore-date"

# load custom functions, like git
source ~/.config/fish/custom.fish

# auto-load mine 
set -g fish_function_path $fish_function_path ~/.config/fish/my.functions

