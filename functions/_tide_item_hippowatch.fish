function _tide_item_hippowatch
#   set -l DOWN "↓"
#   set -l UP "↑"

   set -l DOWN "⬇"
   set -l UP "⬆"

   set -l background_color 00AFFF
   # E4E4E4
   set -l foreground_up FFFFFF
   set -l foreground_down FF0000

   # find backup directory file
   set -l backup_file ".backup.directory"
   set -l path $PWD

   # go up dir tree until we find backup directory
   while test "$path" != "/" && ! test -e "$path/$backup_file"
       set path (dirname $path)
   end
   # get full file location
   set -l backup_directory_file $path/$backup_file

   if test -e $backup_directory_file
       # file with location
       set -l temp (cat $backup_directory_file)
       set -l pid_file "$temp/.pid"
       
       if test -e $pid_file
           set -l pid (cat $pid_file)
           set result (ps -elf | grep $pid | grep -v grep | wc -l)
           set return_code $status

           if test "$return_code" -eq 0
               # backup not running
               set -g tide_hippowatch_bg_color $background_color
               set -g tide_hippowatch_color $foreground_down

               _tide_print_item hippowatch $DOWN
           else
               # backup running!
               set -g tide_hippowatch_bg_color $background_color
               set -g tide_hippowatch_color $foreground_up
#               set_color --background $background_color
#              set_color --bold $foreground_up
#               echo $UP
               _tide_print_item hippowatch $UP
           end
       else
           # no pid file
           set -g tide_hippowatch_bg_color $background_color
           set -g tide_hippowatch_color $foreground_down

           _tide_print_item hippowatch $DOWN
       end
   end




      
end
