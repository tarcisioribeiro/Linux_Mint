#!/bin/bash
SESSION_NAME="dev"

tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? -eq 0 ]; then
  tmux kill-session -t $SESSION_NAME
fi

tmux new-session -d -s $SESSION_NAME -n 'explorer'
tmux send-keys -t $SESSION_NAME:0 "nvim $HOME" C-m
tmux split-window -h -t $SESSION_NAME:0
tmux select-pane -t $SESSION_NAME:0.1
tmux send-keys "ranger $HOME" C-m

tmux new-window -t $SESSION_NAME:1 -n 'database'
tmux send-keys -t $SESSION_NAME:1 'mysql -u root -p' C-m
tmux split-window -h -t $SESSION_NAME:1
tmux select-pane -t $SESSION_NAME:1.1
tmux send-keys 'journalctl -fu mysql' C-m

tmux new-window -t $SESSION_NAME:2 -n 'monitoring'
tmux send-keys -t $SESSION_NAME:2 'btop' C-m
tmux split-window -h -t $SESSION_NAME:2
tmux select-pane -t $SESSION_NAME:2.1
tmux send-keys 'nvtop' C-m

tmux select-window -t $SESSION_NAME:0
