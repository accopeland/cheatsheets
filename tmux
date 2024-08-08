# description
Window multiplexer

# alternatives
cargo install zellij

# To start tmux:
tmux

# To detach from tmux:
PREFIX d

# To restore tmux session:
$ tmux attach

# To detach an already attached session (great if you are moving devices with different screen resolutions):
$ tmux attach -d

# To display session:
$ tmux ls

# To rename session:
PREFIX $

# To switch session:
PREFIX s

# To start a shared session:
$ tmux -S /tmp/your_shared_session
chmod 777 /tmp/your_shared_session

# To help screen (Q to quit):
PREFIX ?

# save output
https://leanpub.com/the-tao-of-tmux/read#targets
$ tmux save-buffer -a ./out
$ tmux capture-pane -p >> ./out

# send output to target
$ tmux capture-pane -t %16  # save output to buffer which can be :pasted into editor in another pane

# file watch
$ ls -d *.go | entr -c go test ./...

# scripts
tmuxp # python

# tmuxp configs
~/.tmuxp/0.yaml
~/.tmuxp/1.yaml

# save session over reboot
tmux-resurrect
tmux-continuum
tmuxp ?

# plugins
set -g @plugin 'tmux-plugin/tmux-resurrect' # then prefix-I

# send command all windows
bind-key X set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"

# send command all windows -- https://scripter.co/command-to-every-pane-window-session-in-tmux/
$ tmux set-window-option synchronize-panes on
$ tmux send-keys <cmd > # doesn't work
$ tmux run-shell <cmd>
$ tmux bind E command-prompt -p "Command:" "run \"tmux list-panes -a -F '##{session_name}:##{window_index}.##{pane_index}' | xargs -I PANE tmux send-keys -t PANE '%1' Enter\""
# *** works
$ tmux bind B command-prompt -p "Command:" "run  \
	 tmux list-sessions -F '##{session_name}' | xargs -I SESS \
   tmux list-windows  -t SESS          -F 'SESS:##{window_index}'   | xargs -I SESS_WIN \
   tmux list-panes    -t SESS_WIN      -F 'SESS_WIN.##{pane_index}' | xargs -I SESS_WIN_PANE \
   tmux send-keys     -t SESS_WIN_PANE '%1' Enter\""
# *** works
$ tmux bind b command-prompt -p "Command:" "run \" \
   tmux list-panes -a -F '##{session_name}:##{window_index}.##{pane_index}' | xargs -I PANE tmux send-keys -t PANE '%1' Enter\""

# list panes
$ tmux list-panes -s -F "#{session_name}:#{window_index}.#{pane_index}"

# scroll in window: see https://appuals.com/stuck-in-tmux-scroll-up/
PREFIX PageUp/PageDown
PREFIX K  # J vi keys
PREFIX [  # vi keys
PREFIX m  # mouse off ; then wheel up/down; Lclick=copy,  wheelbutton= paste

# reload configuration file
PREFIX : source-file /path/to/file

# Window management
# =================
# To create a window:
PREFIX c

# To go next window:
PREFIX n

# To destroy a window:
PREFIX x

# To switch between windows:
PREFIX [0-9]
PREFIX Arrows

# To split windows horizontally:
PREFIX %

# To split windows vertically:
PREFIX "

# automatic backups
continuum
https://github.com/tmux-plugins/tmux-continuum/blob/master/docs/faq.md
systemctl --user status tmux.service

# broadcast  -- send to all  panes
PREFIX b

# find vim
...

# show options
$ tmux show -g

# cut/paste
PREFIX [     Enter copy mode
PREFIX Space  Start selection
PREFIX Enter   End selection
PREFIX ]       Paste the most recent paste buffer
PREFIX #   List paste buffers - but hwoo to actually use one ???

# plugin manager:
$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#  ssh
https://blog.testdouble.com/posts/2016-11-18-reconciling-tmux-and-ssh-agent-forwarding/

# dotfiles:
.tmux.conf

# find window w process
$ tmux bind-key -T PREFIX W command-prompt -p "Pane w process:" "run-shell 'pane=$(ps -wwwE | grep %% | sed \"1d; s/^.*TMUX_PANE=//;s/ .*//\"); [[ -z \$pane ]] && tmux display-message \"could not find pid\" || tmux switch-client -t \$pane'"

# synchronize panes
$ tmux bind-key -T PREFIX X set-window-option synchronize-panes \; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"

# bindings -- list-keys [-1aN] [-P prefix-string -T key-table] [key]
 lsk -- by default list keys as bind-key commands
 or
 -N for keys in root and prefix key tables, list keys with attached notes and show only the key and note
 -T also lists only keys in key-table.
 -P specifies a prefix to print before each key and -1 lists only the first matching key.
 -a lists the command for keys that do not have a note rather than skipping them.

# list all key bindings
PREFIX ?

# move
$ tmux move-window -s <src> -t <tgt>   # but index must be free

# swap
$ tmux swap-window -s <src> -t <tgt>   # workaround

# bind key for move
$ tmux bind-key S-Left swap-window -t -1
$ tmux bind-key S-Right swap-window -t +1

# complex bind w pipe
$ tmux capture-pane -eJ -S - -E -; \
    set-buffer -n PIPE; \
    new-window -n '|%1' 'tmux save-buffer -b PIPE - | %1'; \
    run-sh 'sleep 1 && tmux delete-buffer -b PIPE'"

# pipe-pane

# resurrect
tmux_opt | ug resurr

# resurrect scripts
~/.tmux/plugins/tmux-resurrect/scripts/

# resurrect files
~/_dotfiles_/tmux/.tmux/resurrect

# Error: resurrect annoying terminal output
# ~/_dotfiles_/tmux/.tmux/plugins/tmux-resurrect/scripts/save.sh # history -r etc.
# Fix: swap send-keys with run-shell so stdout/stderr go to background shell not terminal
    #tmux send-keys -t "$pane_id" "$end_of_line" "$backward_kill_line" "$write_command" "$accept_line"
    #tmux send-keys -t "$pane_id" "$end_of_line" "$backward_kill_line" "$read_command" "$accept_line"
    tmux run-shell -t "$pane_id" "$write_command"
    tmux run-shell -t "$pane_id" "$read_command"

# Error: hung save/restore (resurrect)
#Fix: ps aux | grep tmux && kill duplicate tmux and/or resurrect processes that are hung

# resurrect scripts
/Users/copeland/.tmux/plugins/tmux-resurrect/scripts/

# resurrect files
/Users/copeland/_dotfiles_/tmux/.tmux/resurrect

# Error: can't create windows
# Fix: save session; kill server; restart

# reset
stty sane; printf '\033k%s\033\\\033]2;%s\007' "basename "$SHELL"" "uname -n"; tput reset; tmux refresh

# logs
tmux kill-server
tmux -vv -f/dev/null new
 /Users/copeland/tmux-client-51644.log

# debug
PREFIX-: info

# env
tmux show-environment | grep -v '^-' | sed 's/=\(.*\)$/=\"\1\"/'

# Error: tmux terminfo problem reattach
homebrew upgraded ncurses (from 6.1_1 to 6.2) underneath running tmux and deleted previous ncurses
# Fix
 cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/
 git log master -- Formula/ncurses.rb
 git checkout 512634eea3553d0afaea549cfb5385d15c047b7e
 HOMEBREW_NO_AUTO_UPDATE=1 brew reinstall ncurses
 brew pin ncurses

# Error: hung save/restore (resurrect)
# Fix: ps aux | grep tmux && kill duplicate tmux and/or resurrect processes that are hung

# Error: can't create windows
# Fix:

# Error: hung server
# Fix: sigusr1
$ tmux bind-key k run-shell 'kill -s USR1 -- "-$(ps -o tpgid:1= -p #{pane_pid})"'
$ tmux bind k run-shell "kill -s SIGUSR1 $(cat /proc/#{pane_pid}/task/#{pane_pid}/children)"
$ tmux bind k run-shell "kill -s SIGUSR1 $(ps -h --ppid #{pane_pid} -O stat | grep -o '^[[:blank:]]*[[:digit:]]\\+[[:blank:]]\\+[^[:blank:]]*+' | cut -d ' ' -f2)"

# tmux terminfo problem reattach
# Error:homebrew upgraded ncurses (from 6.1_1 to 6.2) underneath running tmux and deleted previous ncurses
# Fix
$ cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/
$ git log master -- Formula/ncurses.rb
$ git checkout 512634eea3553d0afaea549cfb5385d15c047b7e
HOMEBREW_NO_AUTO_UPDATE=1 brew reinstall ncurses
$ brew pin ncurses

# Error: can't create windows
# Fix: save session; kill server; restart
